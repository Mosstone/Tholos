# import os
# import osproc
# import std/strutils

import  std/strutils,
        osproc,
        # streams,
        os


proc help() =
    echo """[094m
    Language router
    
    Runs the bundled portable binary with the ajascent conda env folder, detected based on file extension

    Supported interpreters:
        elixir
        python
        rust    (via rust-script) (just name the environment 'rust')
        julia
        Perl
        php
        lua
        deno
        scheme  (via racket)
        terraform
        make
        cmake
        ninja
        just

    
    These languages are configured to execute using libraries, included in the conda env. New
    languages can be added using this utility or the included env-setup shell module directly


    Usage: 
        Using port routes the command to the correct compiler, splicing the path:

            "~/project/.engine/port test.py"    >>>     "~/project/.engine/python/bin/python test.py"
            "~/project/.engine/port test.exs"   >>>     "~/project/.engine//elixir/bin/elixir test.exs"


        To add an interpreter to the port, ensure anaconda or miniforge is installed and run:
            port --encode <interpreter>

        Alternatively, follow these instructions:
            $ cd $(dirname $(realpath path/to/port)) # or just be in the right spot
            $ mamba create -n python && mamba activate python
            $ mamba install python micromamba
            $ mamba deactivate
            $ mamba info --envs | grep python
              python                 /home/user/conda/envs/python
            $ cd -r /home/usr/conda/envs/python .
        
        You can now run a file using port as a command router. Everything in the environments
        are accessible. By default this is the interpreter, pipdeptree, and micromamba; which
        can be used to update and install anything into that environment. To add other custom
        environments to your port installation, add a block to the case section at the bottom
        of this file. The location to be specified, unless moved, will be <env>/bin/<binary>
        
        Note that conda-forge has many interpreters, unlike Anaconda which primarily supports
        python. Miniforge is highly recommended for that reason and for it avoiding licensing
        issues.

        Buerer, D. (2025). port (Version 1.0.0) [Computer software]. https://orcid.org/0009-0002-5084-0465
        Licensed under the Apache 2 license
    [0m"""

proc version() =
    echo """[094m
        v1.0.0
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


var language: string
# var arg: string
var arg = paramStr(1)





if paramStr(2) == "--encode":
    echo true
    echo execProcess("env-setup" & paramStr(3))
    quit(0)







#   Scans for the file extension
if fileExists(arg):

    if paramCount() > 0:
        if verbosity == true:  brand()
        language = arg.split('.')[^1]

    # unreachable code
    # else:
    #     echo "[094m    >><<>><<><><><<><>>><><<><><><>>><><<\n\n    NO FILE EXTENSION Dfgsrgrej\n\n    ☢︎💥🍄🔥☢︎[0m"
    #     quit(1)

else:
    echo "[094m    >><< File does not exist...[0m"
    quit(1)






proc main() =
    var loc = getAppDir()
    case language


#<      Elixir
        of "exs":

            proc elixirRun(): string =
                result = execProcess(loc & "/elixir/bin/elixir " & arg)

            if verbosity == true:    stdout.write("\e[94m    Executing...\e[0m")
            flushFile(stdout)
            if quietitude == true:   discard elixirRun()
            if quietitude == false:    echo elixirRun()
            if verbosity == true:    stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")


#<      Python
        of "py":

            proc route(): string =
                result = execProcess(loc & "/python/bin/python " & arg)

            if verbosity == true:   stdout.write("\e[94m    Executing...\e[0m")
            flushFile(stdout)
            if quietitude == true:  discard route()
            if quietitude == false: echo route()
            if verbosity == true:   stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")


#<      Rust
        of "rs":

            proc route(): string =
                result = execProcess(loc & "/rust/bin/rust-script " & arg)

            if verbosity == true:   stdout.write("\e[94m    Executing...\e[0m")
            flushFile(stdout)
            if quietitude == true:  discard route()
            if quietitude == false: echo route()
            if verbosity == true:   stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")


#<      Julia
        of "jl":

            proc route(): string =
                result = execProcess(loc & "/julia/bin/julia " & arg)

            if verbosity == true:   stdout.write("\e[94m    Executing...\e[0m")
            flushFile(stdout)
            if quietitude == true:  discard route()
            if quietitude == false: echo route()
            if verbosity == true:   stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")


#<      perl
        of "pl":

            proc route(): string =
                result = execProcess(loc & "/perl/bin/perl " & arg)

            if verbosity == true:   stdout.write("\e[94m    Executing...\e[0m")
            flushFile(stdout)
            if quietitude == true:  discard route()
            if quietitude == false: echo route()
            if verbosity == true:   stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")


#<      php
        of "php":

            proc route(): string =
                result = execProcess(loc & "/php/bin/php " & arg)

            if verbosity == true:   stdout.write("\e[94m    Executing...\e[0m")
            flushFile(stdout)
            if quietitude == true:  discard route()
            if quietitude == false: echo route()
            if verbosity == true:   stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")


#<      lua
        of "lua":

            proc route(): string =
                result = execProcess(loc & "/lua/bin/lua " & arg)

            if verbosity == true:   stdout.write("\e[94m    Executing...\e[0m")
            flushFile(stdout)
            if quietitude == true:  discard route()
            if quietitude == false: echo route()
            if verbosity == true:   stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")


#<      deno
        of "deno":

            proc route(): string =
                result = execProcess(loc & "/deno/bin/deno " & arg)

            if verbosity == true:   stdout.write("\e[94m    Executing...\e[0m")
            flushFile(stdout)
            if quietitude == true:  discard route()
            if quietitude == false: echo route()
            if verbosity == true:   stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")


#<      scheme (racket)
        of "racket":

            proc route(): string =
                result = execProcess(loc & "/racket/bin/racket " & arg)

            if verbosity == true:   stdout.write("\e[94m    Executing...\e[0m")
            flushFile(stdout)
            if quietitude == true:  discard route()
            if quietitude == false: echo route()
            if verbosity == true:   stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")


#<      terraform
        of "terraform":

            proc route(): string =
                result = execProcess(loc & "/terraform/bin/terraform " & arg)

            if verbosity == true:   stdout.write("\e[94m    Executing...\e[0m")
            flushFile(stdout)
            if quietitude == true:  discard route()
            if quietitude == false: echo route()
            if verbosity == true:   stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")


#<      make
        of "make":

            proc route(): string =
                result = execProcess(loc & "/make/bin/make " & arg)

            if verbosity == true:   stdout.write("\e[94m    Executing...\e[0m")
            flushFile(stdout)
            if quietitude == true:  discard route()
            if quietitude == false: echo route()
            if verbosity == true:   stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")


#<      cmake
        of "cmake":

            proc route(): string =
                result = execProcess(loc & "/cmake/bin/cmake " & arg)

            if verbosity == true:   stdout.write("\e[94m    Executing...\e[0m")
            flushFile(stdout)
            if quietitude == true:  discard route()
            if quietitude == false: echo route()
            if verbosity == true:   stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")


#<      ninja
        of "ninja":

            proc route(): string =
                result = execProcess(loc & "/ninja/bin/ninja " & arg)

            if verbosity == true:   stdout.write("\e[94m    Executing...\e[0m")
            flushFile(stdout)
            if quietitude == true:  discard route()
            if quietitude == false: echo route()
            if verbosity == true:   stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")


#<      justfile
        of "just":

            proc route(): string =
                result = execProcess(loc & "/just/bin/just " & arg)

            if verbosity == true:   stdout.write("\e[94m    Executing...\e[0m")
            flushFile(stdout)
            if quietitude == true:  discard route()
            if quietitude == false: echo route()
            if verbosity == true:   stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")






        else:
            echo "[094m    Unknown extension...\n[0m"

main()
