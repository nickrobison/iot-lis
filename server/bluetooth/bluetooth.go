package bluetooth

import (
	"context"
	"fmt"
	"time"

	"github.com/go-ble/ble"
	"github.com/nickrobison/iot-lis/bluetooth/dev"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

var (
	// TestSvcUUID ...
	TestSvcUUID = ble.MustParse("00010000-0001-1000-8000-00805F9B34FB")
)

// MakeBLEService ...
func MakeBLEService(resultChan chan []byte) error {
	d, err := dev.NewDevice("default")
	if err != nil {
		return err
	}

	ble.SetDefaultDevice(d)

	testSrvc := ble.NewService(TestSvcUUID)
	// Let's make a characteristic
	e := NewEchoCharacteristic(resultChan)
	testSrvc.AddCharacteristic(e)

	err = ble.AddService(testSrvc)
	if err != nil {
		return err
	}

	log.Info().Msg("Listening for 5 hours")

	ctx := ble.WithSigHandler(context.WithTimeout(context.Background(), 5*time.Hour))
	chkErr(ble.AdvertiseNameAndServices(ctx, "IOT-LIS", testSrvc.UUID))
	return nil
}

func chkErr(err error) {
	switch errors.Cause(err) {
	case nil:
	case context.DeadlineExceeded:
		fmt.Printf("done\n")
		return
	case context.Canceled:
		fmt.Printf("canceled\n")
		return
	default:
		log.Error().Err(err).Msg("")
		return
	}
}
