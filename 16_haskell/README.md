# [Day 16](http://adventofcode.com/2016/day/16) in Haskell

Finally! I can start using my top 10 languages! This puzzle is a
straightforward matter of implementation, and it looks beautiful in Haskell.

However, my naive solution does have the slight drawback of bringing my machine
to its knees within seconds when we move to the longer input in part two. One
bottleneck turned out to be generating the data; my guess is that `reverse` on
a long list (nearly 18 million entries) is not exactly efficient. So I made it
smarter, by computing each bit on the fly rather than pasting strings of bits
together. That worked great... until I actually started using the bits, and it
turned out to be still too slow (though no longer chewing up all my RAM). The
other bottleneck was in the checksumming. I made the `checksum` function tail
recursive, but it didn't help.

In the end, the remedy turned out to be to switch to `Data.ByteString.Char8`,
which is just represented as consecutive bytes in memory. For checksumming,
however, I still needed to turn it into a list, which chewed quickly through
RAM again. As it turns out, it helped to force each checksum stage to be
evaluated eagerly by turning it into a `ByteString` too. Somehow all the
unevaluated thunks must have been too much; I admit my understanding of how and
when lazy evaluation works is a bit hazy. But after this change, the program
produced a reasonable looking answer in under a minute.

Not the right answer, though. One final bug I had to squash: by making
`checksum` tail-recursive, I had accidentally made each step reverse the
checksum string. Both the example and the first part of the puzzle have an even
number of steps, so this only showed up in part two, and took me some trial and
error to discover.

Anyway, an interesting puzzle which can elegantly be solved in Haskell. What
more can I say?
