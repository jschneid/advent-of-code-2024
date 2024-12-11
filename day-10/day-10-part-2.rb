def peaks_reachable_from(y, x, map)
  current_height = map[y][x].to_i

  return 1 if current_height == 9

  peaks_reachable = 0
  peaks_reachable += peaks_reachable_from(y - 1, x, map) if y > 0 && map[y-1][x].to_i == current_height + 1
  peaks_reachable += peaks_reachable_from(y + 1, x, map) if y < map.size - 1 && map[y+1][x].to_i == current_height + 1
  peaks_reachable += peaks_reachable_from(y, x - 1, map) if x > 0 && map[y][x-1].to_i == current_height + 1
  peaks_reachable += peaks_reachable_from(y, x + 1, map) if x < map[0].size - 1 && map[y][x+1].to_i == current_height + 1

  peaks_reachable
end

topographic_map = File.readlines("day-10/input.txt").map(&:chomp)

total_trailheads_score = 0
topographic_map.each_index do |y|
  topographic_map[y].each_char.with_index do |height, x|
    if height == '0'
      topographic_map_clone = Marshal.load(Marshal.dump(topographic_map))
      total_trailheads_score += peaks_reachable_from(y, x, topographic_map_clone)
    end
  end
end
p total_trailheads_score
