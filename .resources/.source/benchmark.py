#!/usr/bin/env python


import os
import sys

import time






def printhelp():
    print("""[94m
    Scope adapting microbenchmark. Follow with any command, works fine with complex ones

    benchmark -n <int> to specify number of iterations, default is 1
    [0m""")

def printversion():
    print("""[94m
    v.2.0.2
    [0m""")

def monolithe():

    def runtest():

        global lumiere

        aube = time.time()

        try:
            os.system(' '.join(sys.argv[1:]))
        except IndexError:
            print("[94m    >><< Un argument est requis...")
            sys.exit(1)
        
        soir = time.time()
        lumiere = soir - aube

    runtest()


    def convert():
        global unit
        global scale
        global raw

        if lumiere > 3600:
            unit="heures"
            scale=3600
        elif lumiere > 60:
            unit="minutes"
            scale=60
        elif lumiere > 1:
            unit="secondes"
            scale=1
        elif lumiere > 0.001:
            unit="millisecondes"
            scale=0.001
        elif lumiere > 0.000001:
            unit="microsecondes"
            scale=0.000001
        elif lumiere > 0.000000001:
            unit="nanosecondes"
            scale=0.000000001
        elif lumiere > 0.000000000001:
            unit="picosecondes"
            scale=0.000000000001
        elif lumiere > 0.000000000000001:
            unit="femtosecondes"
            scale=0.000000000000001
        elif lumiere > 0.000000000000000001:
            unit="attosecondes"
            scale=0.000000000000000001
        elif lumiere > 0.000000000000000000001:
            unit="zeptosecondes"
            scale=0.000000000000000000001
        elif lumiere > 0.000000000000000000000001:
            unit="yoctosecondes"
            scale=0.000000000000000000000001
        elif lumiere > 0.0000000000000000000000000000000000000000000000000000001:
            unit="unités de Planck"
            scale=0.0000000000000000000000000000000000000000000000000000001
        else:
            unit="indéfinie"
            scale=0

        #   capture original metric before converting
        if unit != "secondes":
            raw = " (" + str(lumiere) + " secondes)"
        else:
            raw = ''
        

    convert()


def créerLumiere():
    print("\
        [94m\n    commande = "             + \
        ' '.join(sys.argv[1:])              + \
        "\n    mesurage = 0     +[95m "    + \
        str(lumiere/scale) +    "[94m "    + \

        unit + raw + "[0m")


def main():

    recursion = 1

    try:
        match sys.argv[1]:
            case '':
                printhelp()
                quit(0)

            case '-n':
                recursion = int(sys.argv[2])
                sys.argv = sys.argv[2:]
    except IndexError:
        print("[94m    >><< Un argument est requis...[0m")
        sys.exit(1)

    recursion += 1
    while int(recursion) > 1:
        monolithe()
        créerLumiere()
        recursion -= 1
        print("[94m" + str(recursion) + "[0m")

main()