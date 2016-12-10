# [Day 2](http://adventofcode.com/2016/day/2) in Scheme

I'd never worked with a LISP-like language before, apart from some brief Emacs
macros back in the days, before I switched to Vim. For this one, I installed
MIT/GNU Scheme. I have no idea what I'm doing, otherwise I would have looked at
[this StackOverflow question](http://stackoverflow.com/q/2521477/14637) first
and used Racket instead.

This puzzle didn't seem particularly suitable for functional programming
because it's easier to do if you can manipulate state (the current location on
the keypad), but of course it's perfectly possible using a fold (i.e. `reduce`)
operation. And, as it turns out, Scheme also has the `set!` function so I
didn't even have to write this in a purely functional style, although I ended
up doing so.

This was one of the puzzles I'd solved in Python before, so I knew part two
before it arrived. This helped in the choice of data structure; in particular,
by padding the keypad with spaces, bounds checks become unnecessary. In this
way, part two was a simple matter of adjusting the appropriate variables.

Most of the problems I encountered along the way had to do with things being
the wrong type: a one-character string instead of a character, a `(lambda (x)
(...))` list instead of the actual "applicable" function it represented, and so
on. I used the REPL to debug these bit by bit, which is why the code is
structured as a number of top-level definitions.

I'm aware that this code is far from optimal, using O(n) list indexing (albeit
into short lists) and not using tail recursion in places. I don't really care,
because I don't think I ever want to get deeper into LISP. On paper, it sounds
very elegant that definitions, expressions, functions and basically everything
else is a parenthesized list; in practice, it just makes wildly different
things all look the same and makes for unreadable code.
