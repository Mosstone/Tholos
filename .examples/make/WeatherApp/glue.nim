import osproc
# import streams
import os

proc help() =
    echo """[094m
    Calls the elixir backend to perform an api call from a golang layer, getting the weather in paris and then printing it as stdout
    [0m"""

proc version() =
    echo """[094m
    v1.0.0
    [0m"""

# Default flags
# var quietitude = false
# var verbosity = false

proc arguments() =

    # if paramCount() == 0:
    #     help()
    #     quit(0)

    for arg in commandLineParams():

        case arg
            of "--help":
                help()
                quit(0)
            of "--version":
                version()
                quit(0)

            # of "--quiet":
            #     quietitude = true

            # of "--verbose":
            #     verbosity = true

            else:
                discard
arguments()






##############################################################################################################################






proc main() =

    proc check(): string =
        result = execProcess(getAppdir() & "/src/elixirtest.exs")

    stdout.write("\e[94m\n    Looking outside...\n")
    echo "    " & check()
    stdout.write("\e[0m")

main()
