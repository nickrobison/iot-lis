package parser

import (
	flatbuffers "github.com/google/flatbuffers/go"
	protocols "github.com/nickrobison/iot-lis/LIS/Protocols"
	"github.com/rs/zerolog/log"
)

// SerializeToFlatBuffers serializes a payload to a flatbuffers byte array
func SerializeToFlatBuffers(res *HSTIMPayload) (*[]byte, error) {
	log.Debug().
		Int("Orders", res.Order.SequenceNumber).
		Int("Results", len(res.Results)).
		Msg("Order information")
	// Convert to flatbuffers
	builder := flatbuffers.NewBuilder(1024)

	// Build patient

	patientID := builder.CreateString(res.Patient.PatientID)
	patientLoc := builder.CreateString(res.Patient.Location)
	protocols.PatientStart(builder)
	protocols.PatientAddSequenceNumber(builder, int32(res.Patient.SequenceNumber))
	protocols.PatientAddPatientId(builder, patientID)
	protocols.PatientAddLocation(builder, patientLoc)
	patient := protocols.PatientEnd(builder)

	// Build order
	orderID := builder.CreateString(res.Order.OrderID)
	typeName := builder.CreateString(res.Order.TestTypeName)
	operatorID := builder.CreateString(res.Order.OperatorID)
	sampleType := builder.CreateString(string(res.Order.SampleType))

	protocols.OrderStart(builder)
	protocols.OrderAddSequenceNumber(builder, int32(res.Order.SequenceNumber))
	protocols.OrderAddOrderId(builder, orderID)
	protocols.OrderAddTestTypeName(builder, typeName)
	protocols.OrderAddOperatorId(builder, operatorID)
	protocols.OrderAddSampleType(builder, sampleType)
	order := protocols.OrderEnd(builder)

	// Build results
	results := make([]flatbuffers.UOffsetT, len(res.Results))
	for idx, result := range res.Results {
		aName := builder.CreateString(result.AnalyteName)
		tValue := builder.CreateString(result.TestValue)
		tUnits := builder.CreateString(result.TestUnits)
		tRType := builder.CreateString(result.TestResultType)
		protocols.ResultStart(builder)
		protocols.ResultAddSequenceNumber(builder, int32(result.SequenceNumber))
		protocols.ResultAddAnalyteName(builder, aName)
		protocols.ResultAddTestValue(builder, tValue)
		protocols.ResultAddTestUnits(builder, tUnits)
		protocols.ResultAddTestResultType(builder, tRType)
		protocols.ResultAddTimestamp(builder, result.Timestamp.Unix())
		results[idx] = protocols.ResultEnd(builder)
	}

	// Build header
	// TODO: We probably don't need to send the header on each test result.
	// TODO: We can probably ignore delimeters, but we'll see
	// protocols.HeaderStartDelimetersVector(builder, len(res.Header.Delimeters))
	// for _, delim := range res.Header.Delimeters {
	// 	d := builder.CreateString(delim)
	// 	builder.PrependUOffsetT(d)
	// }
	// delims := builder.EndVector(len(res.Header.Delimeters))

	headerName := builder.CreateString(res.Header.Name)
	headerSerialNumber := builder.CreateString(res.Header.SerialNumber)
	headerProcessingID := builder.CreateString(string(res.Header.ProcessingID))
	headerFWVersion := builder.CreateString(res.Header.FWVersion)
	protocols.HeaderStart(builder)
	protocols.HeaderAddName(builder, headerName)
	protocols.HeaderAddSerialNumber(builder, headerSerialNumber)
	// TODO: This should actually be a single byte
	protocols.HeaderAddProcessingId(builder, headerProcessingID)
	protocols.HeaderAddFwVersion(builder, headerFWVersion)
	protocols.HeaderAddTimestamp(builder, res.Header.Timestamp.Unix())
	// protocols.HeaderAddDelimeters(builder, delims)
	header := protocols.HeaderEnd(builder)

	// Build the payload (add everything we've built so far)
	protocols.TestResultStartResultsVector(builder, len(results))
	for _, r := range results {
		builder.PrependUOffsetT(r)
	}
	rOffset := builder.EndVector(len(results))
	protocols.TestResultStart(builder)
	protocols.TestResultAddHeader(builder, header)
	protocols.TestResultAddPatient(builder, patient)
	protocols.TestResultAddOrder(builder, order)
	protocols.TestResultAddResults(builder, rOffset)

	tResult := protocols.TestResultEnd(builder)
	builder.Finish(tResult)
	msgBytes := builder.FinishedBytes()

	return &msgBytes, nil
}
