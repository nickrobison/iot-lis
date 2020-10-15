package main

import (
	"fmt"
	"io"
	"net"
	"net/http"
	"net/http/httputil"
	"os"

	"github.com/nickrobison/iot-lis/parser"
	"github.com/rs/zerolog/log"
	"rsc.io/quote"
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

type HSTIMDelim string

const (
	EOT HSTIMDelim = "\004"
	ACK HSTIMDelim = "\006"
)

func hello(w http.ResponseWriter, req *http.Request) {
	log.Print("Hello there")

	err := parser.MakeParser()
	if err != nil {
		panic(err)
	}

	// Dump the request
	requestDump, err := httputil.DumpRequest(req, true)
	if err != nil {
		log.Error().Msg("ACK")
		return
	}

	log.Print(string(requestDump))

	fmt.Fprintf(w, "hello\n")
}

func handleRequest(conn net.Conn) {
	defer conn.Close()
	log.Info().Msg("Handling request")
	buf := make([]byte, 1024)
	// Read the incoming connection into the buffer.
	for {
		log.Info().Msg("Reading")
		reqLen, err := conn.Read(buf)
		if err != nil {
			if err != io.EOF {
				fmt.Println("Error reading:", err.Error())
			}
			break
		}

		trimmedBody := string(buf[0:reqLen])
		log.Info().Int("Request length", reqLen).Msgf("Request body: %s", trimmedBody)

		if trimmedBody == "\004" {
			break
		}

		// Acknowledge
		conn.Write([]byte(ACK))
		// }

	}
	log.Debug().Msg("Stream completed, closing")
}

func main() {
	fmt.Println(quote.Hello())

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

	// http.HandleFunc("/", hello)

	// http.ListenAndServe(":8080", nil)

}
