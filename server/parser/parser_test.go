package parser

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

//
// Comment tests
//
func TestCommentParsing(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	expC := HSTIMComment{
		1,
		"Hello world",
	}
	c, err := p.ParseComment([]byte("C|1||Hello world"))
	assert.Nil(t, err)
	assert.Equal(t, expC, c, "Should be equal")
}

func TestCommentWrongType(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParseComment([]byte("P|\\^&|||Sofia^29029912|||||||P|1.9.0"))
	assert.NotNil(t, err)
	assert.Equal(t, "Not a comment", err.Error())
}

func TestCommentWrongLength(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParseComment([]byte("C|\\^&|||Sofia^29029912|||||||P|1.9.0"))
	assert.NotNil(t, err)
	assert.Equal(t, "Expected 3 fields, got 12", err.Error())
}

func TestCommentWrongSequence(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParseComment([]byte("C|BB|Hello|Nope"))
	assert.NotNil(t, err)
	assert.Equal(t, "Sequence number should always be 1", err.Error())
}

//
// Header tests
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

	h, err := p.ParseHeader([]byte("H|\\^&|||Sofia^29029912|||||||P|1.9.0|20201014160646\r\003A5"))
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

//
// Patient Tests
//
func TestPatient(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	expPatient := HSTIMPatient{
		1,
		"",
		"HHS",
	}

	patient, err := p.ParsePatient([]byte("P|1||||||||||||||||||||||||HHS\r\u0003C2"))
	assert.Nil(t, err)
	assert.Equal(t, expPatient, patient, "Should have patient record")
}

func TestWrongPayloadType(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParsePatient([]byte("L|1||||||||||||||||||||||||HHS\r\u0003C2"))
	assert.NotNil(t, err)
	assert.Equal(t, "Not a patient record", err.Error())
}

func TestWrongSequence(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParsePatient([]byte("P|2||||||||||||||||||||||||HHS\r\u0003C2"))
	assert.NotNil(t, err)
	assert.Equal(t, "Sequence number should always be 1", err.Error())
}

func TestWrongLength(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParsePatient([]byte("P|1|||||||||||"))
	assert.NotNil(t, err)
	assert.Equal(t, "Expected 25 fields, got 12", err.Error())
}

//
// Order tests
//
func TestOrderParsing(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	expOrder := HSTIMOrder{
		1,
		"",
		"SARS",
		"",
		'P',
	}

	o, err := p.ParseOrder([]byte("O|1|||SARS|||||||||||P\r\u000390"))
	assert.Nil(t, err)
	assert.Equal(t, expOrder, o)
}

func TestOrderWrongType(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParseOrder([]byte("P|1|||||||||||"))
	assert.NotNil(t, err)
	assert.Equal(t, "Not an order record", err.Error())
}

func TestOrderWrongLength(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParseOrder([]byte("O|1|"))
	assert.NotNil(t, err)
	assert.Equal(t, "Expected 25 fields, got 2", err.Error())
}

func TestWrongSampleType(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParseOrder([]byte("O|1|||SARS|||||||||||L\r\u000390"))
	assert.NotNil(t, err)
	assert.Equal(t, "Unknown sample type `L`", err.Error())
}

func TestOrderNonIntSequence(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParseOrder([]byte("O|BB|||SARS|||||||||||P\r\u000390"))
	assert.NotNil(t, err)
	assert.Equal(t, "strconv.Atoi: parsing \"BB\": invalid syntax", err.Error())
}

//
// Result tests
//

func TestResultParsing(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	// Create a test timestamp
	tstamp, err := time.Parse(hstimTimeFmt, "20201009164600")
	if err != nil {
		t.Error("Cannot create timestamp")
	}

	expRes := HSTIMResult{
		1,
		"^^^SARS",
		"negative",
		"",
		"",
		"",
		"F",
		tstamp,
	}

	r, err := p.ParseResult([]byte("R|1|^^^SARS|negative|||||F||||20201009164600\r\u000343"))
	assert.Nil(t, err)
	assert.Equal(t, expRes, r, "Should have correct result")
}

func TestResultWrongType(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParseResult([]byte("O|1|||||||||||"))
	assert.NotNil(t, err)
	assert.Equal(t, "Not a result record", err.Error())
}

func TestResultNonIntSequence(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParseResult([]byte("R|BB|||SARS||||||||P\r\u000390"))
	assert.NotNil(t, err)
	assert.Equal(t, "strconv.Atoi: parsing \"BB\": invalid syntax", err.Error())
}

func TestResultWrongLength(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParseResult([]byte("R|1|||SARS||||||||||P\r\u000390"))
	assert.NotNil(t, err)
	assert.Equal(t, "Expected 12 fields, got 14", err.Error())
}

func TestResultMalformedTimeStamp(t *testing.T) {
	p, err := MakeParser()
	if err != nil {
		t.Error("Cannot create parser")
	}

	_, err = p.ParseResult([]byte("R|1|^^^SARS|negative|||||F||||2020-09-01\r\u000343"))
	assert.Equal(t, "Cannot parse `2020-09-01` as valid timestamp", err.Error())
}
