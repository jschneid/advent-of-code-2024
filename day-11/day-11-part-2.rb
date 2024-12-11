def next_iteration(stone)
  if stone == '0'
    ['1']
  elsif stone.length.even?
    stone_a = stone[(stone.length / 2)..].to_i.to_s
    stone_b = stone[..(stone.length / 2) - 1]
    [stone_a, stone_b]
  else
    [(stone.to_i * 2024).to_s]
  end
end

# Since the next iteration for each stone isn't affected by its neighbors -- despite the problem
# statement including "No matter how the stones change, their order is preserved, and they stay
# on their perfectly straight line"! -- we can group all of the stones in the current iteration by
# their values, and calculate the next iteration for each of those values just once. For example,
# if we have 500 "2024" stones, we don't need to calculate 500 times that "2024" => "20", "24"; we
# can just do that once, and then add 500 copies of "20" and "24" to the next iteration.
#
# With this approach, there's no need to memoize the "next iteration" calculation results for each
# stone value. The overall program still runs for 75 iterations in less than one second.
def blink(stone_quantities)
  new_stone_quantities = {}

  stone_quantities.each do |stone, quantity|
    new_stones = next_iteration(stone)
    new_stones.each do |new_stone|
      add_stone(new_stone, new_stone_quantities, quantity)
    end
  end

  new_stone_quantities
end

def add_stone(stone, stone_quantities, quantity)
  if stone_quantities.key?(stone)
    stone_quantities[stone] += quantity
  else
    stone_quantities[stone] = quantity
  end
end

stones = File.read('day-11/input.txt').split

# Set up a map of currently-present stone numbers : how many of each number are present
stone_quantities = {}
stones.each do |stone|
  add_stone(stone, stone_quantities, 1)
end

75.times do
  stone_quantities = blink(stone_quantities)
end

p stone_quantities.values.sum
