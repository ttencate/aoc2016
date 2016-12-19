# [Day 19](http://adventofcode.com/2016/day/19) in Ruby

Now _this_ looks like a proper programming puzzle. There's an obvious brute
force simulation approach, but there is also a more elegant solution. Each
round, half of the elves get eliminated, namely those that have (in the
remaining group) the even indices (if we count from 1, as elves apparently do).
If there is an odd number of elves in that round, the first one is also
eliminated because the last in the circle takes away their presents.

So we can solve this recursively (a `while` loop would also work, but is a bit
harder to reason about): find the solution for `floor(num_elves / 2)`, then map
the index back into the original collection of elves. The base case is when
only one elf is left.
