package trace

import (
	"fmt"
	"log"
	"os"
	"runtime"
	"time"
	"path/filepath"
)

// import "errors"
// func main() {

	
// 	Trace(errors.New("test"))
// 	// Trace(nil)
// }

// Vastly improves readability and coding efficiency, generating error documentation, which otherwise goes the abyss

// Alternative error handling function, more robust and concise than typical blocks. Also available in .modules as a
// dot import but supplied there to keep the thol portable. Just add Trace(err) after anything with an err output to
// to satisfy compiler requirements. This is a fail first method creating a log file in pwd indicating the error and
// line number in the 'locs' folder. To specify change the loc value to point to the path that fails should point to

// This is intentionally kept as a single function. It can either be dot modded in or copied manually, functionality
// is not impacted and the names of the calls do not need to be adjusted. Mind the imports.

// TODO 
// This also contains a metascript. When logs are created, the loc folder gets a utility which collects the logs and
// synthesizes a traceback document within the specified range. The reason for each entry getting its own file is so
// that they constitute parameters in the shape θt ( path, line, error ) where θt is kept in the name
func Trace(err error) {
	if err != nil {

		// the location to save the error file
		loc := "logs"

		// gets julian time 
		now := time.Now().UTC()
    	j := fmt.Sprintf("%02d%03d", now.Year() % 100, now.YearDay())
		julian := fmt.Sprintf(j + now.Format("150405"))
		
		// gets file path and line number
		_, path, line, _ := runtime.Caller(1)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


		msg := fmt.Errorf(">><< Error occurred in file %s at line %d with error: %w", path, line, err)

		os.MkdirAll(loc, 0770)
		output := fmt.Sprintf("%s/%s", loc, julian)
		logErr := os.WriteFile(output, []byte(fmt.Sprintf("%v", msg)), 0600)
		if logErr != nil {
			panic(logErr)
		}

		var realpath, err = filepath.Abs(loc)
		if err != nil {
    		log.Fatal(err)
		}

		fmt.Println("Error log created in: " + realpath)
		log.Fatal(msg)

	}
}
