package bluetooth

import (
	"sync"
	"time"

	"github.com/go-ble/ble"
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
	c.HandleIndicate(ble.NotifyHandlerFunc(e.echoHandler))

	return c
}

type echoChar struct {
	sync.Mutex
	m map[string]chan []byte
}

func (e *echoChar) writeHandler(req ble.Request, rsp ble.ResponseWriter) {
	log.Info().Msgf("Writing %s", string(req.Data()))
	e.Lock()
	e.m[req.Conn().RemoteAddr().String()] <- req.Data()
	e.Unlock()
}

func (e *echoChar) echoHandler(req ble.Request, n ble.Notifier) {
	ch := make(chan []byte)
	remoteAddr := req.Conn().RemoteAddr().String()
	log.Info().Msgf("Subsribing device: %s", remoteAddr)
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
