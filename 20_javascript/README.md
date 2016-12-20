# [Day 20](http://adventofcode.com/2016/day/20) in JavaScript (ES2015)

Just a good warm-up before the day's coding, which will mostly be JavaScript as
well.

Part one is easy: just sort the ranges by start value, run through increasing
your candidate IP address to be beyond each of the ranges, and if you encounter
one that starts after the candidate, you're done.
