This directory contains the solutions for [day
8](http://adventofcode.com/2016/day/8) in Fortran 90.

I had used Fortran before, briefly, in a class about 10 years ago. I knew that
it is suitable for matrix manipulation, and since our LCD screen is just a
boolean matrix, it seemed like a good fit.

The main issue here was reading and parsing the input. There is an equivalent
of `scanf`, but it's limited: you have to specify the width of integer fields
in advance. But there are other input formats you can use that don't have this
restriction; the default `*` format accepts comma-separated values of arbitrary
length. I managed to use this by modifying the input, replacing `=` and ` by `
by `,`.

The matrix manipulation was indeed straightforward, as expected. Of course,
Fortran indices being 1-based and ranges being inclusive, there were some
off-by-one errors to contend with, but nothing too bad. Incidentally, Edsger W.
Dijkstra (of Dijkstra's algorithm fame) wrote in
[EWD831](https://www.cs.utexas.edu/users/EWD/transcriptions/EWD08xx/EWD831.html)
why indices should start at zero, and ranges should exclude their end.
