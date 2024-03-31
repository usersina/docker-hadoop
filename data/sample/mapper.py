#!/usr/bin/python

#
# Extract the necessary data under a list of sorted key/value pairs (store, cost)
#
# Example call:
# head -50 ./data/purchases.txt | ./data/sample/mapper.py
#

import sys

for line in sys.stdin:
    data = line.strip().split("\t")

    if len(data) == 6:
        date, time, store, item, cost, payment = data
        print("{0}\t{1}".format(store, cost))
