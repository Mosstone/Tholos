package main


// Copyright 2025 Daniel Buerer
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import (
_ "embed"
"fmt"
"log"
"os"
"os/exec"
"path/filepath"
"strings"

"crypto/aes"
"crypto/cipher"
"crypto/rand"
"encoding/hex"
// "github.com/google/go-tpm/tpmutil"
// "github.com/google/go-tpm/tpm2"
)

//go:embed .ac69eb468be056345d424e469b2139e7420615a26576bfbd09147404ccfb832b197b16f644010f2f17b041a758d0861f12425fcfdb2447bad01c7e9f9cd01bed.lib/bash
var interpreter []byte

//go:embed thol
var script []byte

// This key is stored in the binary, which is fine for general purpose but not secure unless an external key is used
// Changing the hexKey value to a tpm provided key and commenting this line would result in a fully compliant system
// This is intended to be obfuscation, not security. If security is needed comment this and use the function instead
const hexKey = "642215b24b08bedae32760862760a8ac2b0755a70c8a2922319ca5c1a771f46d"

// func sealKey(device, file string) (string, error) {
//     rwc, err := tpm2.OpenTPM(device)
//     if err != nil {
//         return "", fmt.Errorf("open TPM: %w", err)
//     }
//     defer rwc.Close()

//     primaryHandle, _, err := tpm2.CreatePrimary(rwc, tpm2.HandleOwner, tpm2.PCRSelection{}, "", "", defaultSRKTemplate())
//     if err != nil {
//         return "", fmt.Errorf("CreatePrimary: %w", err)
//     }
//     defer tpm2.FlushContext(rwc, primaryHandle)

//     var key []byte

//     if _, err := os.Stat(file); os.IsNotExist(err) {
//         key = make([]byte, 32)
//         if _, err := rand.Read(key); err != nil {
//             return "", fmt.Errorf("generate key: %w", err)
//         }

//         sealedBlob, _, err := tpm2.Seal(rwc, "", "", key, nil)
//         if err != nil {
//             return "", fmt.Errorf("seal key: %w", err)
//         }

//         if err := os.WriteFile(file, sealedBlob, 0600); err != nil {
//             return "", fmt.Errorf("write sealed blob: %w", err)
//         }

//     } else {
//         sealedBlob, err := os.ReadFile(file)
//         if err != nil {
//             return "", fmt.Errorf("read sealed blob: %w", err)
//         }

//         key, err = tpm2.Unseal(rwc, sealedBlob, "")
//         if err != nil {
//             return "", fmt.Errorf("unseal key: %w", err)
//         }
//     }

//     return hex.EncodeToString(key), nil
// }

// func defaultSRKTemplate() tpm2.Public {
//     return tpm2.Public{
//         Type:       tpm2.AlgRSA,
//         NameAlg:    tpm2.AlgSHA256,
//         Attributes: tpm2.FlagStorageDefault &^ tpm2.FlagAdminWithPolicy,
//         RSAParameters: &tpm2.RSAParams{
//             Symmetric: &tpm2.SymScheme{
//                 Alg:     tpm2.AlgAES,
//                 KeyBits: 128,
//                 Mode:    tpm2.AlgCFB,
//             },
//             Sign: &tpm2.SigScheme{
//                 Alg:  tpm2.AlgRSASSA,
//                 Hash: tpm2.AlgSHA256,
//             },
//             KeyBits: 2048,
//             ModulusRaw: make([]byte, 256),
//         },
//     }
// }

// Create a nonce in the scope of the location invoked in. As long as it is not passed outside of the scope, it will
// not be misused, and any short lived encrypted files will remain secure
func sealNonce() []byte {

rng := make([]byte, 12)
_, err := rand.Read(rng)
if err != nil {
log.Fatalf("Failed to create nonce: %v", err)
}
return rng

}

// var RuntimeNonce = sealNonce()
//      Uncomment to expose a nonce which can be used to encrypt ephemeral files used by the embed or its outputs
//      A new nonce is created each time the embed is executed
//      Follow with this line to zero the nonce and ensure the nonce is not accidentally reused:
//      for i := range runtimeNonce { runtimeNonce[i] = 0 }

// Encrypt a plaintext as byte input, which can be decrypted with sealBreak
// The key is stored in the binary created when this module was built, thus any encrypted keys can only be decrypted
// by binaries which use this specific module as an import. Built modules could be used for a form of key management
// controlling scope by which binaries import the same port modules. Since several modules may be used for different
// binaries, it may not immediately obvious to an outside observer which modules are being used as a key group since
// a port copy of an innocent file, or even different versions of the same module, can be used for binaries to share
// the same module keys and be able to decrypt each other's messages built through that module.
func sealMake(plaintext []byte) ([]byte, error) {

key, err := hex.DecodeString(hexKey)
if err != nil {
log.Fatalf("Failed to transbobulate keys: %v", err)
}

block, err := aes.NewCipher(key)
if err != nil {
return nil, err
}

gcm, err := cipher.NewGCM(block)
if err != nil {
return nil, err
}

nonce := sealNonce()
ciphertext := gcm.Seal(nonce, nonce, plaintext, nil)

return ciphertext, nil

}

// Decrypt a ciphertext as a byte input, which can be created with sealMake, using the key tied to this specific module
func sealBreak(ciphertext []byte) ([]byte, error) {

if len(ciphertext) < 12 {
return nil, fmt.Errorf("ciphertext too short")
}
key, err := hex.DecodeString(hexKey)
if err != nil {
log.Fatalf("Failed to transbobulate keys: %v", err)
}

nonce := ciphertext[:12]
defer func() {
for i := range nonce {
nonce[i] = 0
}
}()

ciphertext = ciphertext[12:]
block, err := aes.NewCipher(key)
if err != nil {
return nil, err
}

gcm, err := cipher.NewGCM(block)
if err != nil {
return nil, err
}

return gcm.Open(nil, nonce, ciphertext, nil)

}

func sealExample(message string) string {

var bytes = []byte(message)
var err error
// fmt.Println(string(bytes))

bytes, err = sealMake(bytes)
if err != nil {
log.Fatalf("sealMake failed: %v", err)
}
// fmt.Println(string(bytes))

bytes, err = sealBreak(bytes)
if err != nil {
log.Fatalf("sealBreak failed: %v", err)
}
// fmt.Println(string(bytes))
message = string(bytes)

return message
}

func main() {

//  The path for the interpreter, but not the libraries, to be used at runtime. Falls back to the system interpreter if
//  present, but is generally portable unless libraries are used. This is cached after the first run of the session, so
//  subsequent executions are marginally faster. Uses a hash of the username and int name by default, but can be easily
//  changed here to a specific location or deleted to only use the system interpreter
    intPath := fmt.Sprintf("%s/98ef454e7a4fe29930057dadf8079d0b815af5ec2aeed23c095b1c75afa5519f", "/dev/shm/.98ef454e7a4fe29930057dadf8079d0b815af5ec2aeed23c095b1c75afa5519f")
os.MkdirAll(filepath.Dir(intPath), 0755)
errEmbedInt := os.WriteFile(intPath, interpreter, 0755)
if errEmbedInt != nil {
log.Fatalf("Failed to write embedded interpreter: %v", errEmbedInt)
}

//  The name of the interpreter being used for the embed for the module. Determines which execution logic to use, which
//  flags are needed, and whether to use stdin or write to a file
    interp := "bash"
parts := strings.Fields(interp)
    parts = append(parts, "-s") // Interpreter flags injected here (or it's just this comment)
parts = append(parts, os.Args[1:]...)

//	Determines whether the interpreter can use stdin or if it needs a file to be written. Consider setting this to static
//  needsFile = true if a real file is required. Any tmp file created will be encrypted and then deleted by default, this
//  can be changed to cache the file instead farther down. Notably, this is fully compatible with sealMake and works fine
//  if executed outside of an embed, subject to aes encryption standards.
var needsFile bool
switch interp {
case "rust-script", "deno", "Rscript", "scala", "wolframscript", "racket", "luatex":
needsFile = true
default:
needsFile = false
} //  fmt.Println(needsFile)

var tmpPath string
if needsFile {

        tmpPath = fmt.Sprintf("%s/a2852d44ef57c16aa0bde6e9ab55851c595bd5b9b0a31628451bf125ca60df14", "/dev/shm/.a2852d44ef57c16aa0bde6e9ab55851c595bd5b9b0a31628451bf125ca60df14/")
os.MkdirAll(filepath.Dir(tmpPath), 0755)

if err := os.WriteFile(tmpPath, script, 0755); err != nil {
log.Fatalf("Failed to write embedded script: %v", err)
}
defer os.Remove(tmpPath)
parts = append(parts, tmpPath)

}

//  Executes the embedded file, using the custom library path but falling back to system libraries if anything is missing
cmd := exec.Command(intPath, parts[1:]...)
    cmd.Env = append(os.Environ(), "LD_LIBRARY_PATH=./.ac69eb468be056345d424e469b2139e7420615a26576bfbd09147404ccfb832b197b16f644010f2f17b041a758d0861f12425fcfdb2447bad01c7e9f9cd01bed.lib")
cmd.Stdout = os.Stdout
cmd.Stderr = os.Stderr

//  Sends the file to stdin if the interpreter is in a language that supports is, otherwise writes to memory temporarily
//  To modify behaviour, add or remove interpreters from needsFile above
if !needsFile {
stdinPipe, err := cmd.StdinPipe()
if err != nil {
log.Fatalf("Failed to create stdin pipe: %v", err)
}

if err := cmd.Start(); err != nil {
log.Fatalf("Failed to start interpreter: %v", err)
}

_, err = stdinPipe.Write(script)
if err != nil {
log.Fatalf("Failed to write script to interpreter stdin: %v", err)
}
stdinPipe.Close()
} else {
if err := cmd.Start(); err != nil {
log.Fatalf("Failed to start interpreter: %v", err)
}
}

if err := cmd.Wait(); err != nil {
log.Fatal(err)
}

for i := range interpreter {
interpreter[i] = 0
}
for i := range script {
script[i] = 0
}
}


