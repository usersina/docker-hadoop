#!/usr/bin/python
import sys

current_store = None
current_total_sales = 0
max_total_sales = 0
max_selling_store = None

for line in sys.stdin:
    store, cost = line.strip().split("\t")
    if not cost.replace(".", "", 1).isdigit():
        continue
    cost = float(cost)

    if current_store != store:
        if current_store:
            if current_total_sales > max_total_sales:
                max_total_sales = current_total_sales
                max_selling_store = current_store
        current_total_sales = 0
        current_store = store
    current_total_sales += cost

if current_store:
    if current_total_sales > max_total_sales:
        max_total_sales = current_total_sales
        max_selling_store = current_store

if max_selling_store:
    print(max_selling_store)
