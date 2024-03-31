#!/usr/bin/python
import sys

for line in sys.stdin:
    data = line.strip().split("\t")

    if len(data) == 6:
        store = data[2]
        print("{0}\t1".format(store))
