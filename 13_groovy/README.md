# [Day 13](http://adventofcode.com/2016/day/13) in Groovy

So far, my exposure to the JVM-based Groovy language has been limited to
writing some custom rules for the Gradle build system (used for building
Android apps, among others). It always confuses me, especially its scoping,
which sometimes seems to make variables appear out of nowhere (might be a
Gradle thing) so I'm taking this opportunity to get a bit more familiar with
the basics.

I found [this tutorial by Tim
Roes](https://www.timroes.de/2015/06/27/groovy-tutorial-for-java-developers/)
to be just what I needed. It explains succinctly what's different when moving
from Java to Groovy, and does a great job at demystifying the syntax I've been
encountering in Gradle files.

So... it's obvious what is required in this puzzle. We're writing another path
finding algorithm. The distance "as the taxicab crow flies" from `1, 1` to `31,
39` is small enough that a simple Dijkstra should work; no need to bother with
A\* or other optimizations. The key thing here is that the grid is infinite, so
we can't represent anything as a matrix. Instead, we'll use sets and maps of
coordinate pairs.
