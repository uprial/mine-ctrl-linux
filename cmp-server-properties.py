#! /usr/bin/env python3

import sys

def get_file_content(filename):
    with open(filename, "r") as filehandle:
        return filehandle.read()

def get_data(filename):
    data = {}
    content = get_file_content(filename)
    lines = content.split("\n")
    for line in lines:
        parts = line.split("=")
        if len(parts) == 2:
            key = parts[0]
            value = parts[1]
            data[key] = value

    return data

def compare(filename1, filename2):
    data1 = get_data(filename1)
    data2 = get_data(filename2)
    for key, value in data1.items():
        if key not in data2:
            print ("Key '" + key + "' is not exists in '" + filename2 + "'")
        elif data2[key] != value:
            print ("Value of key '" + key + "' differs: '" + value + "' vs. '" + data2[key] + "'")

    for key, value in data2.items():
        if key not in data1:
            print ("Key '" + key + "' is not exists in '" + filename1 + "'")

def main():
    filename1 = sys.argv[1]
    filename2 = sys.argv[2]
    compare(filename1, filename2)

if __name__ == "__main__":
    main()
