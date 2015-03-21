#! /usr/bin/env python

import os
import sys

def listfiles(dirname):
    return [filename for filename in os.listdir(dirname) if os.path.isfile(os.path.join(dirname, filename))]

def k(value):
    return value / 500

def main(): 
    print "ACCESS DENIED"
    sys.exit(1)
    x1 = k(-1000+1)
    x2 = k(1000-1)
    z1 = k(-1000+1)
    z2 = k(2000-1)
    dirname = os.path.realpath(sys.argv[0])
    dirname = os.path.dirname(os.path.dirname(dirname))
    dirname = os.path.join(dirname, "world")
    dirname = os.path.join(dirname, "region")
    for filename in listfiles(dirname):
        parts = filename.split(".")
        if parts[0] == "r" and parts[3] == "mca":
            x = int(parts[1])
            z = int(parts[2])
            if x > x2 or x < x1 or z > z2 or z < z1:
                os.remove(os.path.join(dirname, filename))
                #print filename + ": " + str(x) + "," + str(z)

if __name__ == "__main__":
    main()
