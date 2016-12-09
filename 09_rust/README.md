# [Day 9](http://adventofcode.com/2016/day/9) in Rust

I never used Rust before, but I know it's supposed to be "a better C", with a
strong emphasis on safety. This sort of language seems suitable for fairly
straightforward input-to-output conversion needed in this puzzle.

First impressions of the Rust language are really good! It looks well designed,
nice and explicit in everything. None of the "magic" that is supposed to make
things easy but often just ends up confusing me. Compiler warnings are super
helpful too (e.g. `denote infinite loops with loop` when naive me used `while
true`). Error handling is explicit (no exceptions), like in Go, but you do get
the tools to make it less tedious, unlike in Go. Documentation, as far as I've
seen it, is amazing. And it distinguishes properly between bytes and characters.

The first part of the problem was straightforward. Fortunately, each run of
digits is followed by a non-digit character, so I don't need to worry about
gobbling that up as a terminator. And each opening parenthesis indeed starts a
valid marker.
