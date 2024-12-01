left_list = []
right_list = []
File.foreach('day-01/input.txt') do |line|
  location_ids = line.split.map(&:to_i)
  left_list << location_ids[0]
  right_list << location_ids[1]
end

left_list.sort!
right_list.sort!

total_difference = 0
left_list.each_with_index do |left, index|
  total_difference += (left - right_list[index]).abs
end

p total_difference
