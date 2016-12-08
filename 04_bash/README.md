This directory contains the solutions for [day
4](http://adventofcode.com/2016/day/4) in the Bash shell language (plus some
standard Unix utilities).

Thanks to regular expression matching, parsing the input was easy.

In the first part of the problem, I computed the checksums with a nice shell
pipeline: `grep -o` to pick out each letter on a separate line, `sort | uniq
-c` to count occurrences for each letter, `sort -rns` to sort stably by
occurrence count, then `head -n5` to pick the top 5, and finally another `grep`
and a `tr` to concatenate the characters into a single line.

For the second part, `tr` does the job nicely. I feed it the original alphabet
and a "rotated" version of the alphabet, and it maps each character to the
corresponding decrypted character. This gives a list of decrypted names.
Finally, the output of the entire `while` loop is piped through `grep` to find
the line we're looking for.
