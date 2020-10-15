package parser

import (
	"fmt"
	"strconv"
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

// HSTIMPayload defines an entire payload from the device,
// including the header, patient info and other results
type HSTIMPayload struct {
	Header   HSTIMHeader
	Patient  HSTIMPatient
	Order    HSTIMOrder
	Results  []HSTIMResult
	Comments []HSTIMComment
}

// HSTIMComment defines a payload of device specific comments
type HSTIMComment struct {
	SequenceNumber int
	TestMode       string
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

// HSTIMOrder defines the order information for the requested test
type HSTIMOrder struct {
	SequenceNumber int
	OrderID        string
	TestTypeName   string
	OperatorID     string
	SampleType     rune
}

// HSTIMPatient defines the patient demographic information for the given test results
type HSTIMPatient struct {
	SequenceNumber int
	PatientID      string
	Location       string
}

// HSTIMResult defines the result of the lab order
type HSTIMResult struct {
	SequenceNumber int
	AnalyteName    string
	TestValue      string
	TestUnits      string
	ReferenceRange string
	TestFlag       string
	TestResultType string
	Timestamp      time.Time
}

func removeTrailingValues(msg []byte) string {
	return strings.Split(string(msg), "\r\003")[0]
}

// HSTIMParser is a parser for HSTIM messages
type HSTIMParser struct {
}

// ParseComment parses the given message as an HSTIM comment
func (h *HSTIMParser) ParseComment(msg []byte) (HSTIMComment, error) {
	c := HSTIMComment{}
	// Verify the first character is `C`, which indicates it's a comment
	if (msg[0]) != 'C' {
		return c, &ParseError{fmt.Sprintf("Not a comment")}
	}

	// Slice off everything before <CR><EXT>
	msgStr := removeTrailingValues(msg)

	splits := strings.Split(msgStr[2:], "|")
	if len(splits) != 3 {
		return c, &ParseError{fmt.Sprintf("Expected 3 fields, got %d", len(splits))}
	}

	if splits[0] != "1" {
		return c, &ParseError{"Sequence number should always be 1"}
	}
	c.SequenceNumber = 1
	c.TestMode = splits[2]

	return c, nil
}

// ParseHeader parses the input line and validates it is a wellformed header
func (h *HSTIMParser) ParseHeader(msg []byte) (HSTIMHeader, error) {
	header := HSTIMHeader{}
	header.ProcessingID = 'P'

	// Verify the first character is `H`, which indicates it's a header
	if (msg[0]) != 'H' {
		return header, &ParseError{fmt.Sprintf("Not a header")}
	}

	// Slice off everything before <CR><EXT>
	msgStr := removeTrailingValues(msg)

	// The next 4 characters are always the delimeters
	header.Delimeters = strings.Split(msgStr[1:5], "")

	splits := strings.Split(msgStr[5:], "|")
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

// ParseOrder parses the given message as an HSTIMOrder record
func (h *HSTIMParser) ParseOrder(msg []byte) (HSTIMOrder, error) {
	o := HSTIMOrder{}

	// Verify the first character is `O`, which indicates it's an order record
	// Probably redundant
	if msg[0] != 'O' {
		return o, &ParseError{fmt.Sprintf("Not an order record")}
	}

	msgStr := removeTrailingValues(msg)
	splits := strings.Split(msgStr[2:], "|")
	if len(splits) != 15 {
		return o, &ParseError{fmt.Sprintf("Expected 25 fields, got %d", len(splits))}
	}

	seqNum, err := strconv.Atoi(splits[0])
	if err != nil {
		return o, err
	}
	o.SequenceNumber = seqNum
	o.OrderID = splits[1]
	o.TestTypeName = splits[3]
	o.OperatorID = splits[9]
	sampleType := rune(splits[14][0])
	if 'P' != sampleType && 'Q' != sampleType && sampleType != 'C' {
		return o, &ParseError{fmt.Sprintf("Unknown sample type `%s`", string(sampleType))}
	}
	o.SampleType = rune(sampleType)

	return o, nil
}

// ParsePatient parses the given message as an HSTIMPatient record
func (h *HSTIMParser) ParsePatient(msg []byte) (HSTIMPatient, error) {
	patient := HSTIMPatient{}
	patient.SequenceNumber = 1

	// Verify the first character is `P`, which indicates it's a patient record
	// Probably redundant
	if msg[0] != 'P' {
		return patient, &ParseError{fmt.Sprintf("Not a patient record")}
	}

	msgStr := removeTrailingValues(msg)

	splits := strings.Split(msgStr[2:], "|")
	if len(splits) != 25 {
		return patient, &ParseError{fmt.Sprintf("Expected 25 fields, got %d", len(splits))}
	}

	if splits[0] != "1" {
		return patient, &ParseError{"Sequence number should always be 1"}
	}

	patient.PatientID = splits[1]
	patient.Location = splits[24]

	return patient, nil
}

// ParseResult parses the given message as an HSTIMResult record
func (h *HSTIMParser) ParseResult(msg []byte) (HSTIMResult, error) {
	r := HSTIMResult{}

	// Verify the first character is `R`, which indicates it's a result record
	// Probably redundant
	if msg[0] != 'R' {
		return r, &ParseError{fmt.Sprintf("Not a result record")}
	}

	msgStr := removeTrailingValues(msg)
	splits := strings.Split(msgStr[2:], "|")
	if len(splits) != 12 {
		return r, &ParseError{fmt.Sprintf("Expected 12 fields, got %d", len(splits))}
	}

	seqNum, err := strconv.Atoi(splits[0])
	if err != nil {
		return r, err
	}
	r.SequenceNumber = seqNum
	r.AnalyteName = splits[1]
	r.TestValue = splits[2]
	r.TestUnits = splits[3]
	r.ReferenceRange = splits[4]
	r.TestFlag = splits[5]
	r.TestResultType = splits[7]

	// Parse the time
	t, err := time.Parse(hstimTimeFmt, splits[11])
	if err != nil {
		return r, &ParseError{fmt.Sprintf("Cannot parse `%s` as valid timestamp", splits[11])}
	}
	r.Timestamp = t

	return r, nil
}

// MakeParser returns an HSTIM parser
func MakeParser() (*HSTIMParser, error) {
	return &HSTIMParser{}, nil
}
