# launch.nim







import os
import osproc
# import streams
# import std/strutils


proc help() =
    echo """[094m
        Template application

        Buerer, D. (2025). application (Version 1.0.0) [Computer software]. https://doi.org/words
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

            of "--quiet":
                quietitude = true

            of "--verbose":
                verbosity = true

            else:
                discard
arguments()






##############################################################################################################################


var arg = " "
if paramCount() > 0:
    arg = paramStr(1)
var loc = getAppDir()





proc launchWeatherApp() =

    proc route(): string =
        result = execProcess(loc & "/services/thol/thol " & arg)

    if verbosity:       stdout.write("\e[94m    Executing...\e[0m")
    flushFile(stdout)
    if quietitude:      discard route()
    if not quietitude:  echo route()
    if verbosity:       stdout.write("\r\e[94m  ✓ Executing...done\e[0m\n")

launchWeatherApp()