# [Day 24](http://adventofcode.com/2016/day/24) in C++

So, another pathfinding puzzle. I'm getting quite good at implementing
pathfinding algorithms by now. Today, we need not just one distance, but all
distances between pairs of destinations. One might think that the
Floyd-Warshall all-pairs shortest-paths algorithm is suitable for this, but
it's overkill: it computes distances between _all_ pairs of grid cells, in
O(_n_³) time where _n_ is the number of cells. Instead, I'll use a flood fill
(Dijkstra) from each source node. This will compute each distance twice, but
I'm not sure an A\* run for each pair of destinations would be faster.

But today's puzzle is more than just that: it combines pathfinding with the
Travelling Salesman Problem (TSP). This problem is known to be NP-complete, so
there's not much better I can do than brute forcing all possible orders of
visiting nodes. Fortunately there are only 7 of them, meaning 7! = 5040
permutations to try.
