#!/usr/bin/ruby

class Node
  attr_accessor :index, :pred, :succ

  def initialize(index)
    @index = index
    @pred = nil
    @succ = nil
  end

  def remove
    pred.succ = succ
    succ.pred = pred
  end
end

def remaining_elf_index(num_elves)
  elves = 1.upto(num_elves).map {|index| Node.new(index)}
  0.upto(num_elves - 1) do |i|
    elves[i].pred = elves[(i - 1 + num_elves) % num_elves]
    elves[i].succ = elves[(i + 1) % num_elves]
  end

  current_elf = elves[0]
  victim = elves[num_elves / 2]

  while num_elves > 1 do
    if num_elves % 2 == 0 then
      next_victim = victim.succ
    else
      next_victim = victim.succ.succ
    end
    victim.remove()
    victim = next_victim
    current_elf = current_elf.succ
    num_elves -= 1
  end

  return current_elf.index
end

num_elves = gets().to_i
puts(remaining_elf_index(num_elves))
