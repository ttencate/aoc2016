# [Day 20](http://adventofcode.com/2016/day/20) in JavaScript (ES2015)

Just a good warm-up before the day's coding, which will mostly be JavaScript as
well.

Part one is easy: just sort the ranges by start value, run through increasing
your candidate IP address to be beyond each of the ranges, and if you encounter
one that starts after the candidate, you're done.

Part two has a similar approach, just with a bit more careful bookkeeping. For
convenience, I pushed a sentinel range onto the end which is one past the final
possible IP address. JavaScript's 64-bit doubles let you do that.
