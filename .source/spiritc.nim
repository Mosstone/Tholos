# import os
# import osproc
# import std/strutils

import  std/strutils,
        osproc,
        # streams,
        os


proc help() =
    echo """[094m
    Invokes the correct compiler for a given language using arguments optimized for performance over safety

    Supported compilers:
        Nim
        Elixir  (todo)
        Go
        Rust
        Tholos  (todo)
    [0m"""

proc version() =
    echo """[094m
        v1.2.1
    [0m"""

# Default flags
var quietitude = false
var verbosity = false

proc arguments() =

    if paramCount() == 0:
        help()
        quit(0)

    for arg in commandLineParams():

        case arg
            of "--help":
                help()
                quit(0)
            of "--version":
                version()
                quit(0)

            of "--quiet":
                quietitude = true

            of "--verbose":
                verbosity = true

            else:
                discard
arguments()






##############################################################################################################################






proc brand() =
    let brand = r"""
grep -q \"虚\" /dev/shm/.imNotHere 2> /dev/null || cat <<-'EOF' > /dev/shm/.imNotHere 2> /dev/null

[094m                           .-*%%%*=:.     :.            .            .                .                                   .                                      .                                               
[094m                      :#虚虚虚虚虚虚虚虚虚虚%###%=  _ .      .                  .                      .                                                                                            .            
[094m                  .=虚虚虚虚虚虚虚%#*****-   .                                      .                                                                                   .                               .        
[094m        .  .     -虚虚虚虚虚虚%-                 .        .                                                                              .              .                                                        
[094m             .  =虚虚虚虚虚虚%=      .       .                   .          .                                .                                                                          .                        
[094m              .-%虚虚虚虚虚虚虚*.                                                 .                                          .                                                                                   
[094m      .  ...:*虚虚虚虚虚虚虚虚虚%-  .      .                                                  .                                                                                                                  
[094m        .+虚虚虚虚虚虚虚虚虚虚虚%+.             .   .        .                                                                                           .                                              .        
[094m       =虚虚虚虚虚虚虚虚虚虚虚虚*:                                     .                                                           .                                                 .                           
[094m      -虚虚虚虚虚虚虚虚虚虚虚+         .  .     .                                                                                                                       .                                        
[094m      #虚虚虚虚虚虚虚虚虚*.   .         .     .                                .            .                .                                         .                                                         
[094m      虚虚虚虚虚虚虚虚%*..:=-..                                                 .                                                                                                                                
[094m      %虚虚虚虚虚虚%--  #%%%*:   .   .  .          .                  .                                                                                                                                          
[094m      *虚虚虚虚虚*:  *虚虚虚%=.      :#=                    .                             .                                   .                                  .                                               
[094m      :虚虚虚虚虚#:*虚虚虚虚虚虚虚-:#%%%虚虚:                                                       .                                          .                                                                 
[094m       =虚虚虚虚%:%虚虚虚虚虚虚虚虚+:#虚虚#                       .               .                                                                                                                              
[094m        :%虚虚%+:#虚虚虚虚虚虚虚虚虚=-%虚虚虚#.                                                                                                                                                                  
[094m         .+%虚虚#.=虚虚虚虚虚虚虚虚#:+%虚%=            .                                                                                                                                                         
[094m           .-*%虚*.:%虚虚虚虚虚虚*:=%虚%=.                                                                                                                                                                       
[094m     .      .-=. :+#%虚虚虚%*=..=+=:                                                                                                                                                                             
	EOF

	grep -q \"imNotHere\" /dev/shm/.imAlsoNotHere 2>/dev/null || cat <<-EOF > /dev/shm/.imAlsoNotHere
		cat /dev/shm/.imNotHere
	EOF


	awk -v cols=$(($(tput cols)-8)) '{print substr($0, 1, cols)}' /dev/shm/.imNotHere


	cat <<< [0m
    """
    echo execProcess(brand)






##############################################################################################################################






#   Scans for the file extension
var language: string
var arg: string

if paramCount() > 0:
    if quietitude == false:  brand()
    arg = paramStr(1)
    language = arg.split('.')[^1]

else:
    echo "[094m    dfgsrgreg[0m"
    quit(1)






# Compiler invocations









# proc juliacom(): string =
#     result = execProcess("julia -e 'using PackageCompiler; create_app(\"" & arg & \"", "\" $arg)")









proc main() =
    case language
    
#<      Nim
        of "nim":
            
            proc nimcom(): string =
                result = execProcess("CC=musl-gcc nim c -d:release --opt:speed --mm:orc --passC:-flto --passL:-flto --passL:-static " & arg)

            stdout.write("\e[94m    Compiling Nim...\e[0m")
            flushFile(stdout)
            if verbosity == false:   discard nimcom()
            if verbosity == true:    echo nimcom()
            stdout.write("\r\e[32m  ✓ Compiling Nim...done\e[0m\n")


#<      Elixir
        of "ex":

            proc elixircom(): string =
                result = execProcess("elixirc " & arg)

            stdout.write("\e[94m    Compiling Elixir...\e[0m")
            flushFile(stdout)
            if verbosity == false:   discard elixircom()
            if verbosity == true:    echo elixircom()
            stdout.write("\r\e[32m  ✓ Compiling Elixir...done\e[0m\n")


#<      Go
        of "go":

            proc golangcom(): string =
                result = execProcess("GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags='-s -w' " & arg)

            stdout.write("\e[94m    Compiling Go...\e[0m")
            flushFile(stdout)
            if verbosity == false:   discard golangcom()
            if verbosity == true:    echo golangcom()
            stdout.write("\r\e[32m  ✓ Compiling Go...done\e[0m\n")
            flushFile(stdout)


#<      Julia
        # of "jl":
        #     stdout.write("\e[94m    Compiling Julia...\e[0m")
        #     flushFile(stdout)
        #     if verbosity == false:   discard juliacom()
        #     if verbosity == true:    echo juliacom()
        #     stdout.write("\r\e[32m  ✓ Compiling Julia...done\e[0m\n")


#<      Rust
        of "rs":

            proc rustcom(): string =
                result = execProcess("rustc -C opt-level=3 -C target-cpu=native file.rs " & arg)

            stdout.write("\e[94m    Compiling Rust...\e[0m")
            flushFile(stdout)
            if verbosity == false:   discard rustcom()
            if verbosity == true:    echo rustcom()
            stdout.write("\r\e[32m  ✓ Compiling Rust...done\e[0m\n")


        else:
            echo "[094m    Unknown extension...\n[0m"

main()
