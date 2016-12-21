# [Day 21](http://adventofcode.com/2016/day/21) in Perl

Today is mostly a parsing and string manipulation job, no fancy algorithms or
data structures necessary. So what better language to solve this in than the
king of the regexp, the Practical Extraction and Report Language? Only, I
haven't Perled in maybe ten years or so, and even then I wasn't very
experienced.

Part One was straightforward. Perl doesn't make it very easy to manipulate
strings (oddly), but manipulating arrays is fine, so with a bit of `split` and
`join` I ended up with reasonably good code, which solved the problem.

Part Two was much more interesting! We now need to run backwards through the
input and apply reverse operations. Of course, both `swap` operations are their
own inverse, and so is the `reverse` operation. Rotating by a fixed number of
steps and moving a letter are also easily reversible operations.

That leaves us with the `rotate based on position of letter X` operation. As it
turns out, this one is ambiguous! Consider output `abcde` and `rotate based on
position of letter a`. Both of the following inputs would result in output
`abcde`:

    deabc
    bcdea

`deabc` has the `a` in position 2, so it rotates right by 2 + 1 = 3 places,
giving `abcde`. But `bcdea` has the `a` in position 4, meaning it rotates right
by 4 + 1 + 1 = 6 places (equivalent to just 1), also giving `abcde`. So the
reverser can't be made to work reliably for passwords of length 5. Another way
to see this is to write up a little table (note that two identical values exist
in the `final_index` row):

    index         0  1  2  3  4
    right_shifts  1  2  3  4  6  == index + 1 + (index >= 4 ? 1 : 0)
    final_index   1  3  0  2  0  == (initial_index + shifts) % 5
                        ^-----^

Fortunately, the input is length 8, for which no such ambiguity exists:

    index         0  1  2  3  4  5  6  7
    right_shifts  1  2  3  4  6  7  8  9  == index + 1 + (index >= 4 ? 1 : 0)
    final_index   1  3  5  7  2  4  6  0  == (initial_index + shifts) % 8

I could try generalizing this (I suspect it works for all even-length strings),
but just ended up coding the pattern I read from the table. That worked.

I still feel vaguely dirty after writing Perl. It's just such a weird mongrel
of a language.
