This directory contains the solutions for [day
7](http://adventofcode.com/2016/day/7) in pure 80386 assembly language (nasm
dialect, and without any use of the C library)

Although I did have prior experience with some assembly languages (Z80, 6502,
as well as the fictional TIS-100 and SHENZHEN I/O from Zachtronics games), I
had never touched x86 before, so it took several hours to write all this.

The first part of the puzzle didn't require scanning back and forth, so I could
just read the input character by character and use a kind of state machine to
process it. (Most of the state is kept implicitly by the program counter.)

The second part then had me confounded for a while, because matching up `aba`
to `bab` seemed to require going through previously read input. I thought of
buffering the line before processing it, but finally came up with a more
elegant approach (though probably slower for short lines): keep a table that
maps pairs of characters (e.g. `ab`) to a number (`0`, `1`, `2` or `3`). If
`aba` is detected outside square brackets, we set bit 1 for `ab`; if `aba` is
detected inside square brackets, we set bit 2 for `ba`. In the end, if any
table entry has both bit 1 and bit 2 set (i.e. it is `3`), we have a matching
pair.

Because I was lazy, the table isn't 26×26 entries, but 256×256. That aside,
this code is probably wildly inefficient for other reasons as well; it takes
about 200 ms to run. I think this is because the table is processed byte by
byte, rather than dword by dword; each subsequent write has to wait for the
previous one to finish, because it affects the same 32 bits. This is about the
worst possible scenario for pipelining. If I figured out how to align the table
to a 4-byte boundary, I could zero it out 4 bytes at a time and also test for
presence of `3`s 4 bytes at a time (by `and`ing with a right-shifted version of
the dword). But whatever, I can afford to wait 200 milliseconds.
