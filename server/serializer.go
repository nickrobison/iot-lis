package main

import (
	flatbuffers "github.com/google/flatbuffers/go"
	protocols "github.com/nickrobison/iot-lis/LIS/Protocols"
	"github.com/nickrobison/iot-lis/parser"
)

// SerializeToFlatBuffers serializes a payload to a flatbuffers byte array
func SerializeToFlatBuffers(res *parser.HSTIMPayload) (*[]byte, error) {
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
	protocols.TestResultStart(builder)
	protocols.TestResultAddHeader(builder, header)
	protocols.TestResultAddPatient(builder, patient)
	tResult := protocols.TestResultEnd(builder)
	builder.Finish(tResult)
	msgBytes := builder.FinishedBytes()

	return &msgBytes, nil
}
