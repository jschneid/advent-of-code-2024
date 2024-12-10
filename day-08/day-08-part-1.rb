require "set"

class Point
  attr_accessor :y, :x

  def initialize(y, x)
    @y = y
    @x = x
  end

  def eql?(other)
    other.is_a?(Point) && @y == other.y && @x == other.x
  end

  def hash
    @y.hash ^ @x.hash
  end
end

def antenna_locations(map)
  result = {}
  map.each_with_index do |line, y|
    line.each_char.each_with_index do |char, x|
      antenna = map[y][x]
      next if antenna == '.'

      if result.key?(antenna)
        result[antenna] << Point.new(y, x)
      else
        result[antenna] = [Point.new(y, x)]
      end
    end
  end
  result
end

def get_antinode_locations(antenna_point_a, antenna_point_b)
  dy = (antenna_point_b.y - antenna_point_a.y)
  dx = (antenna_point_b.x - antenna_point_a.x)
  antinode_c = Point.new(antenna_point_a.y - dy, antenna_point_a.x - dx)
  antinode_d = Point.new(antenna_point_b.y + dy, antenna_point_b.x + dx)
  [antinode_c, antinode_d]
end

def in_bounds?(map, point)
  return false if point.y < 0 || point.y >= map.length
  return false if point.x < 0 || point.x >= map[0].length
  true
end

map = File.readlines("day-08/input.txt").map(&:chomp)
antennas = antenna_locations(map)
antinode_locations = Set[]

antennas.each_key do |frequency|
  antennas[frequency].combination(2).each do |pair|
    locations = get_antinode_locations(pair[0], pair[1])
    antinode_locations.add(locations[0]) if in_bounds?(map, locations[0])
    antinode_locations.add(locations[1]) if in_bounds?(map, locations[1])
  end
end

p antinode_locations.count
