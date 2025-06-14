import  strutils
import  osproc
import  os
# import  times
import threadpool


var version = "v.2.3.1"


proc printHelp() =
    echo """[094m
    Invokes the correct compiler for a given language using arguments optimized for performance over safety

    Arguments:                          Flags:
        spiritc     <target>.<ext>    | --verbose
                                      | --quiet         
                                      | -o          <target>
                                      | --project

    
    Output is in the same directory as source unless -o is present. If -o and nothing following pwd is used

    Supported compilers:
        Nim
        Elixir
        Go
        Rust
        Julia


    For julia, there are two modes. Default spiritc builds uses create_executable() which produces a binary
    Using the --project flag while targeting a .jl module uses create_app() instead, creating a environment
    directory at the location of the target (no -o specification for this), along with a symlink to execute
    the module with. This comes injected with a Recompile.jl file at the project root, which can be used to
    build diffs into the new precompile. The --project is intended to be used as a base for larger projects
    in julia, whereas the default build is to be used for standalone executables with faster execution time







    Buerer, D. (2025). Spirit Compile (""" & version & """) [Computer software]. https://doi.org/10.5281/zenodo.15605336 https://github.com/Mosstone/Spirit-Compile
    [0m"""

proc printVersion() =
    echo """[094m
        """ & version & """

    [0m"""

# Default flags
var quietitude = false
var verbosity = false
var destination = false
var buildProject = false

var outputflag = "null"

proc arguments() =

    if paramCount() == 0:
        printHelp()
        quit(0)

    for arg in commandLineParams():

        case arg
            of "--help":
                printVersion()
                printHelp()
                quit(0)

            of "--version":
                printVersion()
                quit(0)

            of "--quiet":
                quietitude = true
            of "-q":
                quietitude = true

            of "--verbose":
                verbosity = true
            of "-v":
                verbosity = true

            of "--output":
                destination = true
                outputflag = "--output"
            of "-o":
                destination = true
                outputflag = "-o"

            of "--project":
                buildProject = true

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


    #   Snake Mono
const animationSnakeMono = [" ⠁", " ⠉", " ⠙", " ⠛", " ⠟", " ⠿", " ⠾", " ⠶", " ⠦", " ⠤", " ⠠", " ⠡"]; discard animationSnakeMono
    #   Snake
const animationSnake = ["⠉⠀", "⠉⠁", "⠉⠉", "⠋⠉", "⠛⠉", "⠛⠋", "⠛⠛", "⠛⠻", "⠛⠿", "⠻⠿", "⠿⠿", "⠾⠿", "⠶⠿", "⠶⠾", "⠶⠶", "⠶⠦", "⠶⠤", "⠦⠤", "⠤⠤", "⠠⠤", " ⠤", "⠁⠠"]; discard animationSnake
    #   Rotary Mono
const animationRotary = [" ⠋", " ⠙", " ⠹", " ⠸", " ⠼", " ⠴", " ⠦", " ⠧", " ⠇", " ⠏"]; discard animationRotary
    #   Rotary Carve
const animationCarve = ["⠊ ", "⠉⠉", " ⠑", " ⠸", " ⠔", "⠤⠤", "⠢ ", "⠇ "]; discard animationCarve
    #   Rotary Banner
const animationBanner = ["⠟⠁", "⠛⠛", "⠈⠻", " ⠿", "⠠⠾", "⠶⠶", "⠷⠄", "⠿ "]; discard animationBanner
    #   Shiny
const animationShiny = ["⠋⠴", "⠟⠡", "⠿⠟", "⠾⠿", "⠴⠿", "⠡⠾"]; discard animationShiny
    #   Bloom
const animationBloom = ["⠰⠆", "⠪⠕", "⠅⠨", "⠆⠰", "⠤⠤", "⠴⠦"]; discard animationBloom


#  	⠁	⠂	⠃	⠄	⠅	⠆	⠇	⠈	⠉	⠊	⠋	⠌	⠍	⠎	⠏
# ⠐	⠑	⠒	⠓	⠔	⠕	⠖	⠗	⠘	⠙	⠚	⠛	⠜	⠝	⠞	⠟
# ⠠	⠡	⠢	⠣	⠤	⠥	⠦	⠧	⠨	⠩	⠪	⠫	⠬	⠭	⠮	⠯
# ⠰	⠱	⠲	⠳	⠴	⠵	⠶	⠷	⠸	⠹	⠺	⠻	⠼	⠽	⠾	⠿

var spinning = false
var spinnerThread: Thread[string]

proc spinnerLoop(name: string) {.thread, gcsafe.} =
    var i = 0
    while spinning:
        stdout.write("\r\e[94m " & animationBloom[i mod animationBloom.len] & " Compiling "  & name & "...\e[0m")
        flushFile(stdout)
        i.inc
        sleep(100)  # 100 ms between frames

proc startSpinner(name: string) =
    spinning = true
    createThread(spinnerThread, spinnerLoop, name)

proc stopSpinner(name: string) =
    spinning = false
    joinThread(spinnerThread)
    stdout.write("\r\e[94m  ✓ Compiling "  & name & "...done\e[0m\n")
    flushFile(stdout)


##############################################################################################################################






#   Scans for the file extension
var language: string
var arg: string

if paramCount() > 0:
    if verbosity == true:  brand()
    arg = paramStr(1)
    language = arg.split('.')[^1]

else:
    echo "[094m    No arguments passed...[0m"
    quit(1)






proc main() =
    case language
    
#<      Nim
        of "nim":
            # name = "Nim"
            proc build(): string =
                result = execProcess("CC=musl-gcc nim c -d:release --opt:speed --mm:orc --passC:-flto --passL:-flto --passL:-static " & arg)

            if not quietitude: startSpinner("Nim")
            if not quietitude: flushFile(stdout)
            if not verbosity:  discard build()
            if verbosity:      echo build()
            if not quietitude: stopSpinner("Nim")


#<      Elixir
        of "ex":

            proc build(): string =
                result = execProcess("elixirc " & arg)

            if not quietitude: startSpinner("Elixir")
            if not quietitude: flushFile(stdout)
            if not verbosity:  discard build()
            if verbosity:      echo build()
            if not quietitude: stopSpinner("Elixir")


#<      Go
        of "go":

            proc build(): string =
                result = execProcess("GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags='-s -w' " & arg)

            if not quietitude: startSpinner("Go")
            if not quietitude: flushFile(stdout)
            if not verbosity:  discard build()
            if verbosity:      echo build()
            if not quietitude: stopSpinner("Go")


#<      Julia
        of "jl":
        #   DONT    TOUCH   ANYTHING    djfGDSHSP💥

        #   if --project is used, uses create_app which can be used as a base for a larger julia project. Use Recompile.jl to 
            proc buildEnv(): string =
                let uuid = execProcess("julia -e \"using UUIDs; println(UUIDs.uuid4())\"").strip()
                let script = """
                    uuid="""" & uuid & """"
                    arg="""" & arg & """"
                    package=$(basename "$arg" .jl)_module
                    echo "package is $package"

                    nonce=".$(openssl rand -hex 32)"
                    path=/dev/shm/$nonce

                    mkdir -p "$path/staging/src"
                    cp "$(realpath $arg)" "$path/staging/src/$package-body.jl"
                    prevdir="$(realpath .)"
                    cd "$path/staging"

                    cat <<-EOF > "$path/staging/src/$package.jl"
						module $package


						include("$package-body.jl")
						function julia_main()::Cint
						    main()
                            return 0
						end


						end
					EOF

                    cat <<-EOF > "$path/staging/precompile.jl"
						using $package


						$package.julia_main()
					EOF

                    cat <<-EOF > "$path/staging/Project.toml"
						name = "$package"
						uuid = "$uuid"
						authors = ["Daniel Buerer"]
						version = "1.0.0"
					EOF

                    cat <<-EOF > "$path/staging/instantiate.jl"
						#!/usr/bin/env julia


						using PackageCompiler

						create_sysimage(
							["${arg::-3}_module"], 
							sysimage_path="Project.so";
							project = normpath(@__DIR__),
							incremental=true
						)
					EOF

                    julia --project=. -e "using Pkg; Pkg.add(\"PackageCompiler\"); using PackageCompiler; create_app(\".\", \"build/\", precompile_execution_file=\"precompile.jl\", force=true)"

                    mkdir -p $(realpath "$prevdir")/"$arg"_env/
                    cp -a $(realpath "$path"/staging) $(realpath "$prevdir")/"$arg"_env/
                    ln -s $(realpath "$prevdir"/"$arg"_env/staging/build/bin/"${arg::-3}"_module) $(realpath "$prevdir"/"${arg::-3}")
                    cd $prevdir
                    
                    chmod +x "$prevdir"/"$arg"_env/staging/instantiate.jl
                    "$prevdir"/"$arg"_env/staging/instantiate.jl

                    # test link
                    $(realpath "$prevdir"/"${arg::-3}")

                    rm -fr $path
                    """
                echo execProcess("bash -c '" & script & "'")

            if not quietitude: startSpinner("Julia")
            if not quietitude: flushFile(stdout)

            if not buildProject:
                if verbosity:        echo "\e[94m    schmoject schode"
                # if not verbosity:  discard buildEnv()
                # if verbosity:      echo buildEnv()

            if buildProject:
                if verbosity:        echo "\e[94m    Project Mode: building full environment with create_app()\n\e[0m"
                if quietitude:       discard buildEnv()
                if not quietitude:   echo buildEnv()


            if not quietitude:
                stopSpinner("Julia")


#<      Rust
        of "rs":

            proc build(): string =
                result = execProcess("rustc -C opt-level=3 -C target-cpu=native file.rs " & arg)

            if not quietitude: startSpinner("Rust")
            if not quietitude: flushFile(stdout)
            if not verbosity:  discard build()
            if verbosity:      echo build()
            if not quietitude: stopSpinner("Rust")


        else:
            echo "[094m    Unknown extension...\n[0m"
            quit(1)

#<  if -o is passed as an argument, moves the compiled output to the location passed in the following argument
    if destination:

        proc loc(): string =

            var mut: string = paramStr(commandLineParams().find("-o") + 2)
            var loc = ""
            try:
                loc = expandFilename(mut)
            except:
                echo "\n    [095m>><<[094m " & mut & " does not exist or is not a directory[0m"
            return loc


        var script: string = """
            src="""" & paramStr(1).rsplit('.', 1)[0] & """"
            loc="""" & loc() & """"

            mv $src $loc

        """
        echo execProcess("bash -c '" & script & "'")

main()
