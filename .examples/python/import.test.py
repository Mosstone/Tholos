#!/usr/bin/env python

import numpy
import sacred

print("numpy version: " + numpy.__version__)    #   This is likely installed to the system but not present in the Tholos library. Thus, this should print the same version as the system
print("sacred version: " + sacred.__version__)  # | This is pip installed to ~/Tholos/.libraries/python, but not likely on the system. This will print the Tholos version of sacred, but
                                                # | CLI python will not find the module if missing from the system. Therefore if you run ./import.test.py.bin it should work if numpy is
                                                # | installed systemwide, but if you run ./import.test.py it will result in a traceback if sacred is missing systemwide. If you then pip
                                                # | install numpy to Tholos, all thol binaries will immediately be able to use that numpy, without any system version, no rebuild needed
