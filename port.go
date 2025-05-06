package main

import (
    "log"
    "os"
    "os/exec"
    "fmt"
    "strings"
_ "embed"
)


//go:embed .lib/bash
var interpreter []byte

//go:embed port
var script []byte

func main() {
intPath := fmt.Sprintf("%s/bash", os.TempDir())
errEmbedInt := os.WriteFile(intPath, interpreter, 0755)
if errEmbedInt != nil {
log.Fatalf("Failed to write embedded interpreter: %v", errEmbedInt)
}
defer os.Remove(intPath)

tmpPath := fmt.Sprintf("%s/port", os.TempDir())
errEmbed := os.WriteFile(tmpPath, script, 0755)
if errEmbed != nil {
log.Fatalf("Failed to write embedded script: %v", errEmbed)
}
defer os.Remove(tmpPath)

// Split interpreter args
interp := "bash"
parts := strings.Fields(interp)
if len(parts) == 0 {
log.Fatal("No interpreter specified")
}
parts = append(parts, tmpPath)
parts = append(parts, os.Args[1:]...)

cmd := exec.Command(intPath, parts[1:]...)
cmd.Env = append(os.Environ(), "LD_LIBRARY_PATH=./.lib")
cmd.Stdout = os.Stdout
cmd.Stderr = os.Stderr
cmd.Stdin = os.Stdin

err := cmd.Run()
if err != nil {
log.Fatal(err)
}
}
