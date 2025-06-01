package trace

import (
	"fmt"
	"log"
	"os"
	"runtime"
	"time"
)

func Trace(err error) {
	if err != nil {

		_, path, line, _ := runtime.Caller(0)
		msg := fmt.Errorf(">><< Error occurred in file %s at line %d with error %w", path, line, err)

		loc := "logs"
		os.MkdirAll(loc, 0755)
		output := fmt.Sprintf("%s/error-log-%s.txt", loc, time.Now().Format("2006-01-02-15-04-05"))
		logErr := os.WriteFile(output, []byte(fmt.Sprintf("%v", msg)), 0644)
		if logErr != nil {
			panic(logErr)
		}

		log.Fatal(msg)

		// } else {
		// 	fmt.Println("no error")
	}
}

// func main() {
// 	Synth(errors.New("test"))
// 	Synth(nil)
// }
