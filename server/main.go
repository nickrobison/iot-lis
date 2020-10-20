package main

import (
	"bufio"
	"fmt"
	"net"
	"os"
	"strconv"
	"syscall"

	"github.com/nickrobison/iot-lis/bluetooth"

	"github.com/nickrobison/iot-lis/parser"
	"github.com/rs/zerolog/log"
)

// public class ProtocolASCII {

// 	public static char STX = '\002';
// 	public static char ETX = '\003';
// 	public static char ETB = '\027';
// 	public static char EOT = '\004';
// 	public static char ENQ = '\005';
// 	public static char ACK = '\006';
// 	public static char NAK = '\025';
// 	public static char CR = '\r';
// 	public static char LF = '\n';
// 	public static char MOR = '>';
// 	public static char FS = '\034';
// 	public static char GS = '\035';
// 	public static char RS = '\036';
// 	public static char SFS = '\027';
// 	public static char VT = 0x0B; //END OF BLOCK 011

//   }

// HSTIMDelim is an enum which holds various transmission delimeters
type HSTIMDelim string

const (

	// EOT marks the end of the transmission
	EOT HSTIMDelim = "\004"
	// ACK is send by the receiver after each transmission
	ACK HSTIMDelim = "\006"
	// ENQ is the first message sent by the device, to mark a new transmission
	ENQ HSTIMDelim = "\005"
)

func handleRequest(resultChan chan parser.HSTIMPayload, conn net.Conn) {
	defer conn.Close()
	// Since it's possible
	for {
		log.Info().Msg("Handling request")

		// Create a new buffered reader from the connection
		br := bufio.NewReader(conn)

		log.Debug().Int("buffer size", br.Size()).Msg("")

		// Look at the first byte to see what it is
		bt, err := br.ReadByte()
		if err != nil {
			// Determine if the read error is related
			operr, ok := err.(*net.OpError)
			if ok {
				if operr.Err.Error() == syscall.ECONNRESET.Error() {
					log.Debug().Msg("Connection closed by peer")
					return
				}

			}
			log.Error().Err(err).Msg("Cannot read first bytes")
			return
		}

		// Check to ensure we have an ENQ byte
		if string(bt) != "\005" {
			log.Error().Str("msg", string(bt)).Msg("Incorrect ENQ")
			return

		}
		conn.Write([]byte(ACK))

		onCRLF := func(data []byte, atEOF bool) (advance int, token []byte, err error) {
			// Since we're looking at two bytes in a row, we need to take care not to read over the end of the slice
			for i := 0; i < len(data)-1; i++ {
				if string(data[i]) == "\004" {
					return 0, data, bufio.ErrFinalToken
				}
				if string(data[i:i+2]) == "\r\n" {
					return i + 2, data[:i], nil
				}
			}

			// If the final byte is EOT that means the transmission has ended and we can exit
			if string(data[len(data)-1]) == "\004" {
				return 0, data, bufio.ErrFinalToken
			}

			if !atEOF {
				return 0, nil, nil
			}
			return 0, data, bufio.ErrFinalToken
		}
		log.Debug().Msg("Creating scanner")
		scanner := bufio.NewScanner(br)
		scanner.Split(onCRLF)

		payload := parser.HSTIMPayload{}

		log.Debug().Msg("Starting scan")
		for scanner.Scan() {
			msg := scanner.Bytes()
			log.Debug().Str("msg", string(msg)).Msg("Reading from device")
			// If the final byte is EOT, exit out
			if string(msg[0]) == "\004" {
				break
			}

			// The first byte should be STX
			if string(msg[0]) != "\002" {
				log.Error().Msg("Malformed packet, expecting STX as first byte")
			}

			lineNum := func(msg []byte) (msgNumber int, offset int, err error) {
				for idx, b := range msg {
					if '0' <= b && b <= '9' {
						continue
					}
					vs := string(msg[:idx])
					val, err := strconv.Atoi(vs)
					if err != nil {
						return 0, 0, fmt.Errorf("Cannot parse %s as integer", vs)
					}
					// Return the offset, plus one, since we're working with a slice of the original message
					return val, idx + 1, nil
				}

				return 0, 0, nil
			}

			// Get the line number from the byte array
			msgNumber, offset, err := lineNum(msg[1:])
			if err != nil {
				log.Error().Err(err).Msg("Cannot extract line number")
				return
			}
			log.Debug().Int("msg number", msgNumber).Msg("")
			p, err := parser.MakeParser()
			if err != nil {
				log.Error().Err(err).Msg("Cannot create msg parser")
				return
			}
			msgType := msg[offset]

			switch msgType {
			case 'C':
				{
					c, err := p.ParseComment(msg[offset:])
					if err != nil {
						log.Error().Err(err).Msg("Cannot parse comment")
						return
					}
					payload.Comments = append(payload.Comments, c)
					break
				}
			case 'H':
				{
					h, err := p.ParseHeader(msg[offset:])
					if err != nil {
						log.Error().Err(err).Msg("Cannot parse header")
						return
					}
					payload.Header = h
					break
				}
			case 'O':
				{
					o, err := p.ParseOrder(msg[offset:])
					if err != nil {
						log.Error().Err(err).Msg("Cannot parse order")
						return
					}
					payload.Order = o
					break
				}
			case 'P':
				{
					p, err := p.ParsePatient(msg[offset:])
					if err != nil {
						log.Error().Err(err).Msg("Cannot parse patient")
						return
					}
					payload.Patient = p
					break
				}
			case 'R':
				{
					r, err := p.ParseResult(msg[offset:])
					if err != nil {
						log.Error().Err(err).Msg("Cannot parse result")
						return
					}
					payload.Results = append(payload.Results, r)
					break
				}
			case 'L':
				{
					log.Debug().Msg("Received terminator message")
					break
				}
			default:
				{
					log.Error().Msgf("Unknown payload type: `%s`", string(msgType))
				}
			}
			conn.Write([]byte(ACK))
		}
		if err := scanner.Err(); err != nil {
			log.Error().Err(err).Msg("Cannot scan input")
		}

		resultChan <- payload
	}
}

func main() {
	log.Info().Msg("Starting Service")

	l, err := net.Listen("tcp", ":8080")
	if err != nil {
		log.Err(err).Msg("Error")
		os.Exit(1)
	}

	resultChan := make(chan parser.HSTIMPayload)
	msgChan := make(chan []byte)

	go func() {
		err := bluetooth.MakeBLEService(msgChan)
		if err != nil {
			log.Error().Err(err).Msg("BLE issue")
			os.Exit(1)
		}
	}()

	go func() {
		for {
			res := <-resultChan
			log.Debug().Msg("Have result")
			msgBytes, err := parser.SerializeToFlatBuffers(&res)
			if err != nil {
				log.Error().Err(err).Msg("")
			}
			log.Debug().Msgf("Message size: %d", len(*msgBytes))
			msgChan <- *msgBytes
		}
	}()

	defer l.Close()
	for {
		conn, err := l.Accept()
		if err != nil {
			log.Err(err).Msg("Error")
		}
		log.Info().Msg("New request")
		go handleRequest(resultChan, conn)
	}
}
