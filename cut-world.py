#! /usr/bin/env python

import os
import sys

def listfiles(dirname):
    return [filename for filename in os.listdir(dirname) if os.path.isfile(os.path.join(dirname, filename))]

def main(): 
    print "ACCESS DENIED"
    sys.exit(1)
    dirname = os.path.realpath(sys.argv[0])
    dirname = os.path.dirname(os.path.dirname(dirname))
    dirname = os.path.join(dirname, "world")
    dirname = os.path.join(dirname, "region")
    for filename in listfiles(dirname):
        parts = filename.split(".")
        if parts[0] == "r" and parts[3] == "mca":
            x = int(parts[1])
            z = int(parts[2])
            if x > 1 or x < -2 or z > 1 or z < -2:
                os.remove(os.path.join(dirname, filename))
                #print filename + ": " + str(x) + "," + str(z)

if __name__ == "__main__":
    main()
