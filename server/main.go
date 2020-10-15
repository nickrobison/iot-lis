package main

import (
	"bufio"
	"net"
	"os"
	"syscall"

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

func handleRequest(conn net.Conn) {
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

		log.Debug().Msg("Starting scan")
		for scanner.Scan() {
			str := scanner.Text()
			log.Debug().Str("msg", str).Msg("Reading from device")
			conn.Write([]byte(ACK))
			// if str == "\004" {
			// 	log.Debug().Msg("Received EOT, exiting")
			// 	break
			// }

		}
		if err := scanner.Err(); err != nil {
			log.Error().Err(err).Msg("Cannot scan input")
		}
	}
}

func main() {
	log.Info().Msg("Starting Service")

	l, err := net.Listen("tcp", ":8080")
	if err != nil {
		log.Err(err).Msg("Error")
		os.Exit(1)
	}

	defer l.Close()
	for {
		conn, err := l.Accept()
		if err != nil {
			log.Err(err).Msg("Error")
		}
		log.Info().Msg("New request")
		go handleRequest(conn)
	}
}
