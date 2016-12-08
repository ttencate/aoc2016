# [Day 6](http://adventofcode.com/2016/day/6) in R

R is a language designed for statistical computing. Because we're counting and
working with matrices (of characters), it seemed like a good fit. I had never
worked with R before, so this was a bit of a challenge.

The main problem was to understand R's data types (array, vector, list, matrix,
and something called a "factor") and how to use them. The end result is a
oneliner (albeit a long one), in which swapping out `which.max` for `which.min`
gave the solution to the secord part of the puzzle.
