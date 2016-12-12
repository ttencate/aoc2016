# [Day 12](http://adventofcode.com/2016/day/12) in OCaml

I hade never used OCaml before, but I have been following [this blog
series](https://ericlippert.com/2016/02/01/west-of-house/) in which Eric
Lippert develops a Z-machine in OCaml. The language we need to implement in Day
12 is trivial compared to that, but I can borrow a lot of ideas and syntax from
it.

As seems to be becoming a tradition, reading input was the hardest part. I
struggled to write a function to read the input line by line into a list of
strings. (Such a thing strangely doesn't exist out of the box.) For practice
more than efficiency, I also wanted to make it tail-recursive. Of course there
is some code on StackOverflow, but I wanted to do it myself. Somehow it didn't
work when I wrote

    let input_lines fd =
      let option_line = ... something involving input_line fd ... in
      ...

but it did work when I added the `fd` argument explicitly:

    let input_lines fd =
      let option_line fd = ... something involving input_line fd ... in
      ...

My guess is that OCaml sees that the function `option_line` takes no arguments,
assumes it is pure, and therefore memoizes the result instead of reading a new
line each time. Instead of looking for a way to force re-evaluation for each
line, I simply put in the `fd` parameter and the problem went away.

Anyway, after I had a list of strings, the rest was smooth sailing and the
program gave the right answer on the first try in under 2 seconds.

The second part was an easy change, but did increase runtime to over a minute.
Not that there's much I could have done about that.

First impressions after working with OCaml: conceptually similar to Haskell,
but I haven't seen anything it does better than Haskell. The syntax is a bit
more confusing too (e.g. for generic types), so I see little reason to invest
more time learning OCaml.
