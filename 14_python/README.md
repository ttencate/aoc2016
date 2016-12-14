# [Day 14](http://adventofcode.com/2016/day/14) in Python

This looks similar to Day 5, and the only way to solve it (as far as I can
think of) is by brute force. Initially, I wanted to do this hashing in OpenCL.
But looking at the example, we only need to compute a few tens of thousands of
MD5 sums, so OpenCL is better suited for Day 5 instead.

Thus, I adapted my Python solution of Day 5 to this one. We can easily keep the
hashes in memory, and scan through the subsequent 1000 every time we find a
triplet. We could cache the existence of quintuplets, but it's fast enough as
is.
