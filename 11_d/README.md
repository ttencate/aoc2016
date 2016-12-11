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
