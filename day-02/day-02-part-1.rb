def safe?(levels)
  ascending = levels[0] < levels[1]
  levels.each_cons(2).each do |pair|
    if ascending
      return false unless safe_pair?(pair[0], pair[1])
    else
      return false unless safe_pair?(pair[1], pair[0])
    end
  end
  true
end

def safe_pair?(lesser_level, greater_level)
  greater_level > lesser_level && greater_level - lesser_level <= 3
end

safe_count = 0
File.foreach('day-02/input.txt') do |report|
  safe_count += 1 if safe?(report.split.map(&:to_i))
end

p safe_count
