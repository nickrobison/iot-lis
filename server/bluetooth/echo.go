package bluetooth

import (
	"bytes"
	"io"
	"sync"
	"time"

	"github.com/go-ble/ble"
	"github.com/rs/zerolog/log"
	"github.com/ulikunitz/xz/lzma"
)

var (
	// EchoCharUUID ...
	EchoCharUUID = ble.MustParse("00020000-0002-1000-8000-00805F9B34FB")
)

// NewEchoCharacteristic ...
func NewEchoCharacteristic(resultChan chan []byte) *ble.Characteristic {
	e := &echoChar{m: make(map[string]chan []byte)}
	c := ble.NewCharacteristic(EchoCharUUID)
	c.HandleWrite(ble.WriteHandlerFunc(e.writeHandler))
	c.HandleNotify(ble.NotifyHandlerFunc(e.echoHandler))
	c.HandleRead(ble.ReadHandlerFunc(e.readHandler))
	c.HandleIndicate(ble.NotifyHandlerFunc(e.echoHandler))

	go func() {
		for {
			// Compress before sending
			// Ideally, we'd use zlib, but Swift's decoder throws an error
			// Apparently they compress using a different RFC
			msg := <-resultChan
			var b bytes.Buffer
			z, err := lzma.NewWriter(&b)
			if err != nil {
				log.Error().Err(err).Msg("Cannot create lzma writer")
				break
			}
			z.Write(msg)
			z.Close()

			log.Debug().
				Int("Original", len(msg)).
				Int("compressed", len(b.Bytes())).
				Msg("Compression completed")

			e.SendData(b.Bytes())
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
			err := e.transmitBytes(msg, n)
			if err != nil {
				log.Error().Err(err).Msgf("Cannot write %s", string(msg))
				return
			}
		}
	}
}

func (e *echoChar) transmitBytes(msg []byte, n ble.Notifier) error {

	log.Debug().Msg("Transmitting bytes")
	// 182 Bytes is the maximum we can send along the wire
	transmitBuffer := make([]byte, 175)
	bb := bytes.NewBuffer(msg)

	for {
		// Read into the transmit buffer, if you can
		nBytes, err := bb.Read(transmitBuffer)
		if err != nil {
			// If we have EOF, then we're done.
			if err == io.EOF {
				break
			}
			return err
		}
		log.Debug().Int("bytes read:", nBytes).Msg("")
		if _, err := n.Write(transmitBuffer[:nBytes]); err != nil {
			return err
		}
	}

	// Write EOT to signal no more packets
	log.Debug().Msg("Writing EOT packet")
	if _, err := n.Write([]byte("\004")); err != nil {
		return err
	}
	return nil
}

func (e *echoChar) SendData(msg []byte) {
	e.Lock()
	defer e.Unlock()
	for _, v := range e.m {
		v <- msg
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
