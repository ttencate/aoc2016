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
take care to subtract 1 so we don't count the current node itself.
