# [Day 22](http://adventofcode.com/2016/day/22) in Haxe

Finally another properly algorithmic puzzle. I'm doing this one in Haxe as that
will be the language I'll be coding in the rest of the day, too. Haxe is
designed to compile to other (typically lower level) languages, but it is a
programming language in its own right. Since Haxe grew up alongside the Neko
VM, I'll be using that as the compile target.

With only around 1000 nodes, it's easy enough to brute force the answer to Part
One in O(n²) time, but where's the fun in that? We can do this in O(n log n)
time if we sort the nodes first; once by Used, once by Avail. We run through
the Used array, keeping a pointer into the Avail array, knowing that every node
past the Avail pointer has more space and is therefore also viable. We need to
take care to subtract 1 so we don't count the current node itself. (Slightly
more efficient but less readable would be to subtract `n` at the end.)

Then Part Two. I saw it coming, but this still seems like a complicated problem
to solve in the general case. The example in the puzzle description makes it
look a lot easier and suggests that we're _not_ solving the general case here,
though; and indeed, looking at the input data, most nodes have a size between
85T and 94T, and have between 64T and 73T stored:

    $ tail -n+3 input | sed 's/ \+/ /g' | cut -d' ' -f2 | sort -n | uniq -c
         96 85T
        100 86T
         94 87T
         81 88T
        105 89T
        122 90T
        107 91T
        100 92T
         80 93T
         97 94T
          3 501T
          2 502T
          5 503T
          4 504T
          4 505T
          2 506T
          5 507T
          2 508T
          3 509T
          3 510T
    $ tail -n+3 input | sed 's/ \+/ /g' | cut -d' ' -f3 | sort -n | uniq -c
          1 0T
        105 64T
        106 65T
        109 66T
        101 67T
         97 68T
        101 69T
         93 70T
         84 71T
         95 72T
         90 73T
          2 490T
          9 491T
          1 492T
          1 493T
          3 494T
          1 495T
          2 496T
          6 497T
          5 498T
          3 499T

So this lets us classify the nodes in the same way as in the example, and this
is the result:

    ..................................G
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ..#################################
    ...................................
    ...................................
    ...................................
    ...................................
    ...................................
    ........_..........................

It's not even worth writing a pathfinding algorithm for this; I'll do it by
hand. The operation we have available is moving the `_` by one step, swapping
it with its target location.

* Move 7 steps to the left.
* Move 28 steps up, to the top row.
* Move 32 steps right, next to the `G`:

    ...._G
    ......

* Repeat 33 times:

  * Move 1 right (moves the `G` left).
  * Move 1 down.
  * Move 2 left.
  * Move 1 up.

    ..._G.
    ......

* Move 1 right.

Adding all that up, I find 233 steps, which turns out to be the right answer.
