package main

import (
	. "tholos/.modules/trace"
	"os/exec"
	"fmt"

	"crypto/sha256"
    "encoding/hex"
	"path/filepath"
)


func check() string {

	hasher := sha256.New()
	root, err := filepath.Abs("../..")
	Trace(err)

	cmd := exec.Command("tar", "cf", "-", root)
	// cmd.Stderr = os.Stderr
	cmd.Stdout = hasher
	err2 := cmd.Run()
	Trace(err2)

    return hex.EncodeToString(hasher.Sum(nil))

}


func main() {
	output := check()
    fmt.Println(output)
}
