package bluetooth

import (
	"sync"
	"time"

	"github.com/go-ble/ble"
	flatbuffers "github.com/google/flatbuffers/go"
	"github.com/nickrobison/iot-lis/protocols"
	"github.com/rs/zerolog/log"
)

var (
	// EchoCharUUID ...
	EchoCharUUID = ble.MustParse("00020000-0002-1000-8000-00805F9B34FB")
)

// NewEchoCharacteristic ...
func NewEchoCharacteristic() *ble.Characteristic {
	e := &echoChar{m: make(map[string]chan []byte)}
	c := ble.NewCharacteristic(EchoCharUUID)
	c.HandleWrite(ble.WriteHandlerFunc(e.writeHandler))
	c.HandleNotify(ble.NotifyHandlerFunc(e.echoHandler))
	c.HandleRead(ble.ReadHandlerFunc(e.readHandler))
	c.HandleIndicate(ble.NotifyHandlerFunc(e.echoHandler))

	// Setup a timer to send test data every 10 seconds
	ticker := time.NewTicker(5 * time.Second)
	done := make(chan bool)

	go func() {
		for {
			select {
			case <-done:
				return
			case <-ticker.C:
				log.Debug().Msg("Sending new data")
				e.SendData("Hello from Go")
			}
		}
	}()

	return c
}

type echoChar struct {
	sync.Mutex
	m map[string]chan []byte
}

func (e *echoChar) writeHandler(req ble.Request, rsp ble.ResponseWriter) {
	log.Info().Msgf("Writing `%s` from: `%s`", string(req.Data()), req.Conn().RemoteAddr().String())
	// e.Lock()
	// e.m[req.Conn().RemoteAddr().String()] <- req.Data()
	// e.Unlock()
}

func (e *echoChar) echoHandler(req ble.Request, n ble.Notifier) {
	ch := make(chan []byte)
	remoteAddr := req.Conn().RemoteAddr().String()
	log.Info().Msgf("Subscribing device: %s", remoteAddr)
	e.Lock()
	e.m[remoteAddr] = ch
	e.Unlock()
	log.Info().Msg("Notification subscribed")
	defer func() {
		e.Lock()
		delete(e.m, remoteAddr)
		e.Unlock()
	}()

	for {
		select {
		case <-n.Context().Done():
			log.Info().Msg("Notification unsubscribed")
			return
		case <-time.After(time.Second * 20):
			log.Info().Msg("timeout")
		case msg := <-ch:
			if _, err := n.Write(msg); err != nil {
				log.Error().Err(err).Msgf("Cannot write %s", string(msg))
				return
			}
		}
	}

}

func (e *echoChar) SendData(msg string) {

	builder := flatbuffers.NewBuilder(1024)
	builderMsg := builder.CreateString(msg)
	protocols.EchoSendStart(builder)
	protocols.EchoSendAddValue(builder, builderMsg)
	echoMsg := protocols.EchoSendEnd(builder)
	builder.Finish(echoMsg)
	msgBytes := builder.FinishedBytes()

	e.Lock()
	defer e.Unlock()
	for _, v := range e.m {
		v <- msgBytes
	}
	log.Debug().Msg("Finished sending data")
}

func (e *echoChar) readHandler(req ble.Request, rsp ble.ResponseWriter) {
	remoteAddr := req.Conn().RemoteAddr().String()
	log.Debug().Msgf("Starting device read to %s", remoteAddr)

	e.Lock()
	b := <-e.m[remoteAddr]

	if _, err := rsp.Write(b); err != nil {
		log.Error().Err(err).Msgf("Cannot write %s", string(b))
		return
	}

}
