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
only one elf is left. This algorithm is O(log n), so it gives the right answer
in the blink of an eye.

Then part two. This is getting more messy, and I don't immediately see a
similarly fast solution, so simulation it is. But we can't just put them all in
an array and remove them one by one; that'd result in an O(n^2) solution which
might be too slow for three million elves.

A better solution would involve a circular linked list of elves, with two
pointers, one for the current elf and one for the elf opposite them. But I
tried with the array anyway. It looks like it should give an answer within an
hour or so; I'm sure I can out-code that. The linked list solution produces the
right answer in 3 seconds; still a bit slow, but at least it's O(n) now.

Aside: it's been a while since I last Ruby'd, but heck, I still _like_ this
language. It's a bit quirky, but it's extremely expressive.
