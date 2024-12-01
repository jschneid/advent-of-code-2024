left_list = []
right_list = []
File.foreach('day-01/input.txt') do |line|
  location_ids = line.split.map(&:to_i)
  left_list << location_ids[0]
  right_list << location_ids[1]
end

total_similarity_score = 0
left_list.each do |left_id|
  total_similarity_score += right_list.count(left_id) * left_id
end

p total_similarity_score
