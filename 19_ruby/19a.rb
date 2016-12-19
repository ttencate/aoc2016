#!/usr/bin/ruby

num_elves = gets().to_i
def remaining_elf_index(num_elves)
  if num_elves == 1 then
    1
  else
    if num_elves % 2 == 0 then
      -1 + 2 * remaining_elf_index(num_elves / 2)
    else
      1 + 2 * remaining_elf_index(num_elves / 2)
    end
  end
end
puts(remaining_elf_index(num_elves))
