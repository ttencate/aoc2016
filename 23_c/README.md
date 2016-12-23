# [Day 23](http://adventofcode.com/2016/day/23) in C99

"You should be able to use the same assembunny interpreter for this as you did
there"… ha ha ha, not for the silly Polyglot Challenge programmer. Okay,
rewrite from scratch in C instead of OCaml.

Part One was a quite straightforward implementation of the language. As usual,
parsing was the main hurdle. Once I got the right output on the example, I ran
it on the real input and found the right answer there too.

Then Part Two... changing the initial value of `a` to `12` was easy. But yes,
it took a while to run... "don't bunnies usually multiply?" What could that
mean? Should `inc` be interpreted as `mul`? But it has only one argument, so
multiply what with what?

My next thought was that the input program was actually computing a
multiplication using an inordinate number of `inc` instructions, and we're
supposed to figure out where it does that, and how to make it faster. But I
decided to try some more brute force first, and added `-O3` to the compiler
flags. It came up with the correct answer (around half a billion) in 17
seconds. Thank you, C!
