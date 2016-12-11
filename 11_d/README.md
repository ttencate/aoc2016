# [Day 11](http://adventofcode.com/2016/day/11) in D

The D language is another first for me. I finished porting Day 1 to COBOL
yesterday, so after that I longed for something... slightly more modern. It
looks like we might need speed as well as nontrivial algorithms and data
structures, as well as maybe some bit manipulation to quickly test which
combinations of generators and chips are allowed. Hence, D. I know it's similar
enough to C++ that I should be able to pick it up quickly, and it will let me
save C++ for the future when puzzles get even more difficult.

This puzzle is much harder than any of the previous ones. Where you could
previously just execute the steps and get the right answer, this one looks like
it'll need a pathfinding algorithm. A breadth-first search might already work,
so I'll start with that. If it's too slow, I'll use A\* instead, so I'll keep
the code modular enough to allow for that.

After a few hours of hacking, I got this to work and produce the right answer
on the example input. Sadly, it was too slow on the real thing. I suspect that
the BFS wastes too much time on states it's already visited. I could avoid this
by keeping a set of visited states, which I'd need for A\* anyway.
Unfortunately, it made the program take about twice as long on the example
input.

First impressions of the D language: it's nice, but it tries to repackage all
features that C++ has (and then some), so it is a big and complex language.
Fortunately the complexity does not manifest in the same way as C++, so it
offers a lot of high-level features while still remaining usable. I think I
prefer Rust for its greater simplicity, but I certainly like D too.
