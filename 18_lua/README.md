# [Day 18](http://adventofcode.com/2016/day/18) in Lua

Part One is really straightforward. For good measure, I also
stored the rows in an array (a table really, as this is Lua) so I
could apply a pathfinding algorithm in Part Two. Because surely
that was going to be next, right?

It wasn't. We are just running it over bigger input instead.
Well, sure, I can do that. Takes only 23 seconds to run. I wonder
if any cycles are appearing, i.e. we get back to the same row
configuration after a while. If that's the case, it might be
possible to speed this up at the cost of memory usage.
