# [Day 3](http://adventofcode.com/2016/day/3) in Scala

I'd never used Scala before, but this problem just screamed to have some
functional programming applied to it. It's simple enough that it can be reduced
to a series of typical FP operations like `map` and `count`.

This turned out to be true. The `_` implicit anonymous function parameter makes
it a breeze to use `map`, `filter` and similar functions. I hardly needed to
look at documentation because all these standard functions have standard names.

For the second part, I could use `grouped` to create a sequence of groups of
three, which can be flipped around as required using `transpose` and
subsequently `flatten`ed again. Elegant!
