def count_xmas_originating_from(word_search, y, x, max_y, max_x)
  count = 0
  [-1, 0, 1].repeated_permutation(2) do |permutation|
    count +=1 if search_in_direction?(word_search, y, x, permutation[0], permutation[1], max_y, max_x)
  end
  count
end

def search_in_direction?(word_search, origin_y, origin_x, dy, dx, max_y, max_x)
  (0..3).each do |i|
    y = origin_y + dy * i
    x = origin_x + dx * i
    return false unless in_bounds?(y, x, max_y, max_x)
    return false unless word_search[y][x] == 'XMAS'[i]
  end
  true
end

def in_bounds?(y, x, max_y, max_x)
  return false if y < 0 || y > max_y
  return false if x < 0 || x > max_x
  true
end

word_search = File.readlines("day-04/input.txt")

xmas_found = 0
max_y = word_search.length - 1
max_x = word_search[0].length - 1
(0..max_y).each do |y|
  (0..max_x).each do |x|
    xmas_found += count_xmas_originating_from(word_search, y, x, max_y, max_x)
  end
end

p xmas_found
