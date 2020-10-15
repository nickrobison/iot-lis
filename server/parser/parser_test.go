package parser

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

//
// Header parsing tests
//
func TestHeaderParsing(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	// Create a test timestamp
	tstamp, err := time.Parse(hstimTimeFmt, "20201014160646")
	if err != nil {
		t.Error("Cannot create timestamp")
	}

	exp := HSTIMHeader{
		[]string{
			"|",
			"\\",
			"^",
			"&",
		},
		"",
		"",
		'P',
		"1.9.0",
		tstamp,
	}

	h, err := p.ParseHeader([]byte("H|\\^&|||Sofia^29029912|||||||P|1.9.0|20201014160646"))
	if err != nil {
		t.Errorf("Cannot parse header: %s", err.Error())
	}
	assert.Equal(t, exp, h, "Should have matching header")
}

func TestTooShortHeader(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParseHeader([]byte("H|\\^&|||Sofia^29029912|||||||P|1.9.0"))
	assert.NotNil(t, err)
	assert.Equal(t, "Expected 13 fields, got 12", err.Error())
}

func TestNotHeader(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParseHeader([]byte("P|\\^&|||Sofia^29029912|||||||P|1.9.0"))
	assert.NotNil(t, err)
	assert.Equal(t, "Not a header", err.Error())
}

func TestMalformedTimestamp(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParseHeader([]byte("H|\\^&|||Sofia^29029912|||||||P|1.9.0|2020-01-02"))
	assert.NotNil(t, err)
	assert.Equal(t, "Cannot parse `2020-01-02` as valid timestamp", err.Error())
}
