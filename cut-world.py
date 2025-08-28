#! /usr/bin/env python3

import os
import sys

def listfiles(dirname):
    return [filename for filename in os.listdir(dirname) if os.path.isfile(os.path.join(dirname, filename))]

def k(value):
    return int(value / 500)

def g(value):
    return value * 500

def main():
    #square_radius = 7000
    #x1 = k(-square_radius+1) - 1
    #x2 = k(+square_radius-1) + 1
    #z1 = k(-square_radius+1) - 1
    #z2 = k(+square_radius-1) + 1
    x1 = k(1010)
    x2 = k(7510)
    z1 = k(-10010)
    z2 = k(-3010)
    print ("#!/bin/bash")
    print ("set -e")
    print ("#", ">", g(x1), "<", g(x2), ">", g(z1), "<", g(z2))
    #exit()
    dirname = os.path.realpath(sys.argv[0])
    dirname = os.path.dirname(os.path.dirname(dirname))
    dirname = os.path.join(dirname, "world")
    #dirname = os.path.join(dirname, "world_nether", "DIM-1")
    #dirname = os.path.join(dirname, "world_the_end", "DIM1")
    dirname = os.path.join(dirname, "region")
    for filename in listfiles(dirname):
        parts = filename.split(".")
        if parts[0] == "r" and parts[3] == "mca":
            x = int(parts[1])
            z = int(parts[2])
            if x > x1 and x < x2 and z > z1 and z < z2:
            #if x > x2 or x < x1 or z > z2 or z < z1:
                #os.remove(os.path.join(dirname, filename))
                print("rm " + os.path.join(dirname, filename))

if __name__ == "__main__":
    main()
