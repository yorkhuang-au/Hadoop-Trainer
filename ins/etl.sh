#!/bin/bash
for f in txt/*.txt
do
  cat $f | tr '\n' '\t' > "1"$f
done

hadoop fs -copyFromLocal ./1txt/*.txt /ins/in


