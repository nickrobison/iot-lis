package parser

import (
	"fmt"
	"strings"
	"time"
)

const hstimTimeFmt string = "20060102150405"

// ParseError indicates the given string could not be parsed correctly
type ParseError struct {
	msg string
}

func (e *ParseError) Error() string {
	return e.msg
}

// HSTIMHeader defines the initial payload sent by the analyzer
type HSTIMHeader struct {
	Delimeters   []string
	Name         string
	SerialNumber string
	ProcessingID rune
	FWVersion    string
	Timestamp    time.Time
}

// HSTIMParser is a parser for HSTIM messages
type HSTIMParser struct {
}

// ParseHeader parses the input line and validates it is a wellformed header
func (h *HSTIMParser) ParseHeader(msg []byte) (HSTIMHeader, error) {
	header := HSTIMHeader{}
	header.ProcessingID = 'P'

	// Verify the first character is `H`, which indicates it's a header
	if (msg[0]) != 'H' {
		return header, &ParseError{fmt.Sprintf("Not a header")}
	}

	// The next 4 characters are always the delimeters
	header.Delimeters = strings.Split(string(msg[1:5]), "")

	splits := strings.Split(string(msg[5:]), "|")
	if len(splits) != 13 {
		return header, &ParseError{fmt.Sprintf("Expected 13 fields, got %d", len(splits))}
	}

	header.FWVersion = splits[11]

	// Parse the time
	t, err := time.Parse(hstimTimeFmt, splits[12])
	if err != nil {
		return header, &ParseError{fmt.Sprintf("Cannot parse `%s` as valid timestamp", splits[12])}
	}
	header.Timestamp = t

	return header, nil
}

// MakeParser returns an HSTIM parser
func MakeParser() (*HSTIMParser, error) {
	return &HSTIMParser{}, nil
}
