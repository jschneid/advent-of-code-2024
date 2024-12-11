def blink(stones)
  index = 0
  while index < stones.length do
    stone = stones[index]
    if stone == '0'
      stones[index] = '1'
    elsif stone.length.even?
      stones.insert(index + 1, stone[(stone.length / 2)..].to_i.to_s)
      stones[index] = stone[..(stone.length / 2) - 1]
      index += 1
    else
      stones[index] = (stone.to_i * 2024).to_s
    end
    index += 1
  end
end

stones = File.read('day-11/input.txt').split

25.times do
  blink(stones)
end
p stones.length

