#!/usr/bin/python
import sys

max_count = 0
max_store = None
current_count = 0
current_store = None

for line in sys.stdin:
    store, count = line.strip().split("\t")
    count = int(count)
    if current_store == store:
        current_count += count
    else:
        if current_count > max_count:
            max_count = current_count
            max_store = current_store
        current_store = store
        current_count = count

if current_count > max_count:
    max_count = current_count
    max_store = current_store
if max_store:
    print(max_store)
