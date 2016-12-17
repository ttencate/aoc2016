# [Day 17](http://adventofcode.com/2016/day/17) in C\#

It's been a while since I last C#'ed; .NET 2.0 and generics had just
become a thing. But I've been keeping an eye on the language from the
sidelines, so I have a rough idea of what's being offered nowadays, although
I'll probably end up writing more Java-esque code than necessary.

Today's puzzle is a new combination of this AoC's favourite elements:
pathfinding algorithms and MD5 hashes. This time though, the state is not
just a pair of `x, y` coordinates, but also includes the path we took to
get there. A consequence is that each reachable state can be reached in
only one way, which simplifies the algorithm and data structures a _lot_.

We could use a regular breadth-first search, but it's easy enough in a
fancy-pants language like C# to drop in an A\* heuristic, so I'll do that from
the start. But wait... no built-in priority queue implementation? Seriously? I
could grab one off the internet, but where's the fun in that? I'll roll my own.
