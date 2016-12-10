# [Day 10](http://adventofcode.com/2016/day/10) in Pascal

I'm using Free Pascal, provided in Arch Linux by the `fpc` package. My last
contact with Pascal was a brief stint of Delphi 3 programming, which might give
you an impression of how long ago it was. I'm practically starting from scratch
here.

Since Pascal is not case sensitive, I'm going easy on the Shift key. No idea
whether that is conventional. I'm also going to use type definitions (instead
of integers) because it's nice.

Using some shell pipelining, I found out the ranges for values, bot numbers and
output numbers. I also checked that each bot has exactly one instruction.
However, I did not check that the output will be deterministic: it could be
that two bots are ready at the same time (have two values to give) and the
order in which we run their instructions matters. It could even be that a bot
receives more than two values; I'm going to assume that this doesn't happen.

Lack of array push, pop and find operations makes the code a lot longer than it should have been. Proper set support would also have been nice, but unfortunately there's no way to count the number of elements in a set in Free Pascal. And why is there no built-in array sort procedure? Fortunately I'm sorting only two values.
