# [Day 15](http://adventofcode.com/2016/day/15) with pen and paper

One can argue whether "pen and paper" is really a programming language, but the
human processor is certainly Turing complete, so I'm counting it. Besides, it
was quicker to do it this way than to figure out yet another programming
language!

The naive solution is just to advance time forwards, ticking each disk
forwards, and checking for a solution at each time step. My input contains 6
discs, each with a period that is a distinct prime number. That means the
period of the system (the greatest common divisor of all periods) is simply
their product, 440895 in this case; small enough for brute force even in a slow
scripting language.

However, there is a cleverer method. Consider a disc `i`, with period `p_i` and
starting position `s_i`. The position of the disc is given by `(s_i + t) %
p_i`, so if this number is `0`, the hole is aligned.

Call the unknown time of button press `T`. You know that at `T + i`, disc `i`
has to be at `0`:

    (s_i + T + i) % p_i == 0

Now `s_i + i` is just a constant depending on the disc, say `c_i := s_i + i`:

    (T + c_i) % p_i == 0

A simple enough equation, right? Now consider two discs at once, `i` and `j`.
Both of these need to be true:

    (T + c_i) % p_i == 0
    (T + c_j) % p_j == 0

Let's take the example from the assignment. `c_1 = s_1 + 1 = 4 + 1 = 5`, but we
might as well write `c_1 = 0` because we work modulo 5 for this one. Similarly,
`c_2 = s_2 + 2 = 1 + 2 = 3`, which gives `c_2 = 1` modulo 2.

    (T + 0) % 5 == 0
    (T + 1) % 2 == 0

So we see that the mystery number `T` has to be divisible by `5`, and `T` has
to be odd. Moreover, we're looking for the _smallest_ (nonnegative) `T` for
which this holds, so `0 <= T < 5*2`. Clearly, `5` is the only number that
qualifies. (Because both equations are modulo different prime numbers, there
will always be exactly one solution.) In the worst case, we have to check
`min(2, 5)` candidates.

So now we have a new equation in the same form, that is equivalent to the
previous two combined:

    (T + 5) % 10 == 0

Or in general:

    (T + x_i) % (p_1 * ... * p_i) == 0

We continue in this way, adding a new wheel one at a time and computing the
value of `x_i` by testing a small number of values (at most 19 in this case).
For my input, I found:

    (T + 1 + 0) % 7 == 0
    (T + 2 + 0) % 13 == 0
    =>
    (T + 15) % 91 == 0

    (T + 15) % 91 == 0
    (T + 3 + 2) % 3 == 0
    =>
    (T + 197) % 273 == 0

    (T + 197) % 273 == 0
    (T + 4 + 2) % 5 == 0
    =>
    (T + 1016) % 1365 == 0

    (T + 1016) % 1365 == 0
    (T + 5 + 0) % 17 == 0
    =>
    (T + 17396) % 23205 == 0

    (T + 17396) % 23205 == 0
    (T + 6 + 7) % 19 == 0
    =>
    (T + 139061) % 440895 == 0
    =>
    T = 121834

At this point I got a bit nervous, because what if the second part completely
invalidated my approach? But thankfully, adding the final wheel in the second
part was just another step:

    (T + 139061) % 440895 == 0
    (T + 7 + 0) % 11 == 0
    =>
    (T + 1641746) % 4849845 == 0
    =>
    T = 3208099

And yes, I did use a calculator for all this. A programmable one, even, a
TI-83. If I find some time, I might code this up in TI-BASIC just to be sure
that this entry really counts towards the Polyglot Challenge.
