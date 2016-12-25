# [Day 25](http://adventofcode.com/2016/day/25) in Go

So... another Assembunny interpreter is needed. [I totally called
it.](https://www.reddit.com/r/adventofcode/comments/5jvbzt/2016%5Fday%5F23%5Fsolutions/dbjgatd/)
Although this puzzle input doesn't actually contain a `tgl` instruction. I had
planned to save my strongest language, Java, for last, but decided I'm more in
the mood for Go today.

It might be possible to brute force my way through this. I'll try that first,
and see how far it takes me. If optimizations are necessary, by means of
actually understanding what the program does (e.g. adding a `mul` instruction),
I'll see about that later. To decide whether a sequence "repeats forever" I'll
just abort if a mismatch is found, and print the value of `a` at the start of
each run. If the program hangs for a long time, we might have a winner.

This strategy worked fine (the answer is only 158), if it hadn't been for the
fact that I messed up the arithmetic (checking for `101010...` instead of
`010101...`) and then messed up again by forgetting to reset the program
counter between runs. After fixing those bugs, the answer comes up in the blink
of an eye.

While I was waiting for the buggy program to come up with an answer, I realized
that this puzzle can be reduced to the Halting Problem, which is a classic
example of an undecidable problem in computer science. In other words, in the
general case, no algorithm can exist to solve it!

Also while waiting, I studied the input program in more detail. As it turns
out, it simply prints the binary representation of `a + 2572` backwards over
and over again. Indeed, `158 + 2572 == 0xaaa == 0b101010101010`, and 158 is the
smallest positive value for which this bit pattern occurs (the next lowest
value being `0b1010101010` which would require `a == 682 - 2572 = -1890`).

Let's go through and discuss how I analyzed the program. First, it's helpful to
draw some arrows where the jumps are going. This let me break up the program
into three separate blocks, call them A, B and C, with nearly all jumps
happening within a block.

### Block A

Block A is:

     1  cpy a d
     2  cpy 4 c
     3  cpy 643 b <----+
     4  inc d     <--+ |
     5  dec b        | |
     6  jnz b -2   --+ |
     7  dec c          |
     8  jnz c -5   ----+

For those who (unlike me) didn't brute force their way through Day 23, this
should look familiar. It is a multiplication. The inner loop, instructions 4–6,
simply does this:

    d += b
    b = 0

The outer loop has a similar structure, and translates into this pseudocode
(ignoring changes of values that don't matter, like loop counters):

    d = a
    c = 4
    do {
      b = 643
      d += b
      c--
    } while c != 0

This simply adds the value `643` to `d`, `4` times. Because the first line does
`d = a`, we can simplify block A to

    d = a + 2572

### Block B

Let's skip two lines and move on to block B, which is more complicated:

    11  cpy a b
    12  cpy 0 a
    13  cpy 2 c <---------+
    14  jnz b 2  --+ <--+ |
    15  jnz 1 6    |    | | --> block C (line 21)
    16  dec b   <--+    | |
    17  dec c           | |
    18  jnz c -4 -------+ |
    19  inc a             |
    20  jnz 1 -7 ---------+

For didactic reasons, I'll spoil it up front: this divides `a` by two, and also
leaves a value in `c` that can be converted to the remainder of this division.

Let's look at the inner loop first, lines 13–18. We see a new pattern here,
lines 14–15, which translates into a `jz` (jump-if-zero) instruction: line 15
is only executed if `b` is equal to zero, and is skipped otherwise. The `jnz 1`
construct is simply an unconditional jump, because `1` is always nonzero. Using
that knowledge, the pseudocode translation of the inner loop is:

    c = 2
    do {
      if b == 0 {
        jump to block C
      }
      b--
      c--
    } while c != 0

What happens here? If `b` is large enough, this is the same as doing `b -= 2`.
But as soon as `b` hits `0`, the loop is exited, leaving `c` set to either `2`
(if `b` was even) or `1` (if `b` was odd). In other words, `c = 2 - b%2`.

Now for the outer loop, which pulls all this together:

    b = a
    a = 0
    while true {
      c = 2
      do {
        if b == 0 {
          jump to block C
        }
        b--
        c--
      } while c != 0
      a++
    }

So for each time `b` is decremented by `2`, `a` is incremented by one. And
since `a` started at `0`, this is dividing (rounding down) `a` by `2`! And
because jumping out of the loop leaves a meaningful value in `c`, we can also
know the remainder. That's where block C comes in.

### Block C

This is the rest of the code:

    21  cpy 2 b
    22  jnz c 2  --+ <--+
    23  jnz 1 4    |    | --+
    24  dec b   <--+    |   |
    25  dec c           |   |
    26  jnz 1 -4      --+   |
    27  jnz 0 0          <--+
    28  out b

There is another infinite loop here, which is broken out of as soon as `c ==
0`. There's also another `jz`-like construct. Let's do another pseudocode
translation:

    b = 2
    while true {
      if c == 0 {
        break
      }
      b--
      c--
    }
    output b

We decrement `b` and `c` in tandem, with `b` starting out at `2`, so this is
just computing `b = 2 - c`.

Remember that `c` was `2 - a%2` (for the former value of `a`), so this sets `b
= 2 - 2 - a%2`, which is simply `b = a%2`. In other words, `b` is now the least
significant bit of the value formerly known as `a` (and the current value of
`a` still contains the rest of the bits).

### The main loop

Surrounding blocks B and C, there are some straightforward instructions:

     9  cpy d a   <----+
    10  jnz 0 0   <--+ |
    ..  [block B]    | |
    ..  [block C]    | |
    29  jnz a -19  --+ |
    30  jnz 1 -21  ----+

The outer loop will run forever. The inner one runs until `a == 0`. So this
translates to the following pseudocode:

    while true {
      a = d
      while a != 0 {
        block B
        block C
      }
    }

And because blocks B and C together compute the division and remainder of `a`
divided by `2`, we can reduce the entire program to this:

    d = a + 2572
    while true {
      a = d
      while a != 0 {
        b = a % 2
        a /= 2
        output b
      }
    }

Now it's easy to see what this does. It prints the binary representation of `d`
over and over again, starting at the least significant bit. We need to find the
smallest `a > 0` such that the binary representation of `a + 2572` looks like
`1010...10`. The first such number is `101010101010` (six repetitions), which
is 2730 in decimal, giving `a == 2730 - 2572 == 158`.
