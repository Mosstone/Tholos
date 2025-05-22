package main

import (
    "log"
    "os"
    "os/exec"
    "fmt"
    "strings"
    _ "embed"
    "path/filepath"
	"crypto/rand"
)


//go:embed .2245a4b211a94eebfb50ee011b91b63cf85538db37cc30db2a5326daa9f7fee15c8e9318739be1e95206f0057829536a9c052148f5c97754da5d5aa8611df8aa.lib/bash
var interpreter []byte

//go:embed port
var script []byte


func noncegen() []byte {
	rng := make([]byte, 12)
    _, err := rand.Read(rng)
	if err != nil {
        log.Fatalf("Failed to create nonce: %v", err)
    }
	return rng
}


// func generateNonce(size int) []byte {
//     nonce := make([]byte, size)
//     _, err := rand.Read(nonce)
//     if err != nil {
//         log.Fatalf("Failed to generate nonce: %v", err)
//     }
//     return nonce
// }


func main() {














    nonce := noncegen()
    key := "test"

	fmt.Println(nonce)
    fmt.Println(key)
















    intPath := fmt.Sprintf("%s/b1eb1d986eae58028aa64530ed287c5a3c2c5caf4225247f6cd0d0c5ba79fd3e42716fda1603ec5d2ed452f1045a23bd2922f52ad29ee3c8b12e541ee835b3d6", "/dev/shm/.b1eb1d986eae58028aa64530ed287c5a3c2c5caf4225247f6cd0d0c5ba79fd3e42716fda1603ec5d2ed452f1045a23bd2922f52ad29ee3c8b12e541ee835b3d6")
    os.MkdirAll(filepath.Dir(intPath), 0755)
    errEmbedInt := os.WriteFile(intPath, interpreter, 0755)
    if errEmbedInt != nil {
        log.Fatalf("Failed to write embedded interpreter: %v", errEmbedInt)
    }

    tmpPath := fmt.Sprintf("%s/b1eb1d986eae58028aa64530ed287c5a3c2c5caf4225247f6cd0d0c5ba79fd3e42716fda1603ec5d2ed452f1045a23bd2922f52ad29ee3c8b12e541ee835b3d6", "/dev/shm/.67eddf7968bbfbdfd9d9a52b7e2109e239dcef4e9a2efcc84bb367a1d1246014e490097df63694301e1bf127b03e42784fbbcb2ae3d57adf25ab7513635331e2/")
    os.MkdirAll(filepath.Dir(tmpPath), 0755)
    errEmbed := os.WriteFile(tmpPath, script, 0755)
    if errEmbed != nil { log.Fatalf("Failed to write embedded script: %v", errEmbed) }

    interp := "bash"
    parts := strings.Fields(interp)
    if len(parts) == 0 { log.Fatal("No interpreter specified") }
    parts = append(parts, tmpPath)
    parts = append(parts, os.Args[1:]...)

    cmd := exec.Command(intPath, parts[1:]...)
    cmd.Env = append(os.Environ(), "LD_LIBRARY_PATH=./.2245a4b211a94eebfb50ee011b91b63cf85538db37cc30db2a5326daa9f7fee15c8e9318739be1e95206f0057829536a9c052148f5c97754da5d5aa8611df8aa.lib")
    cmd.Stdout = os.Stdout
    cmd.Stderr = os.Stderr
    cmd.Stdin = os.Stdin

defer func() {
_ = os.Remove(tmpPath)
}()

    err := cmd.Run()
    if err != nil {
        log.Fatal(err)
    }
}
