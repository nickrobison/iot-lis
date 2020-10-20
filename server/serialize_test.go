package main

import (
	"testing"
	"time"

	protocols "github.com/nickrobison/iot-lis/LIS/Protocols"
	"github.com/nickrobison/iot-lis/parser"
	"github.com/stretchr/testify/assert"
)

func TestSimpleSerialization(t *testing.T) {
	// Create a test timestamp
	tstamp, err := time.Parse(time.RFC3339, "2012-11-01T22:08:41+00:00")
	if err != nil {
		t.Error("Cannot create timestamp")
	}

	p := parser.HSTIMPayload{}
	p.Header = parser.HSTIMHeader{
		[]string{"\\", "!", "-"},
		"test-header",
		"SN12345",
		'P',
		"v1.2.34",
		tstamp,
	}

	p.Patient = parser.HSTIMPatient{
		1,
		"test-patient-1",
		"test-location",
	}

	b, err := SerializeToFlatBuffers(&p)
	assert.Nil(t, err)

	// Serialize back
	result := protocols.GetRootAsTestResult(*b, 0)
	assert.Equal(t, "test-patient-1", string(result.Patient(nil).PatientId()), "Should have matching patient name")
	assert.Equal(t, "v1.2.34", string(result.Header(nil).FwVersion()), "Should have correct serial number")

	// Try to parse out the timestamp
	nTime := time.Unix(result.Header(nil).Timestamp(), 0)
	assert.Equal(t, tstamp.Unix(), nTime.Unix(), "Timestamp should be equal")
	assert.Equal(t, 0, result.OrdersLength(), "Should not have orders")
}
