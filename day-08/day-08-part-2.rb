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

def get_antinode_locations(map, antenna_point_a, antenna_point_b)
  dy = (antenna_point_b.y - antenna_point_a.y)
  dx = (antenna_point_b.x - antenna_point_a.x)

  antinodes = []

  antinode = antenna_point_a
  while in_bounds?(map, antinode)
    antinodes << antinode
    antinode = Point.new(antinode.y - dy, antinode.x - dx)
  end

  antinode = antenna_point_b
  while in_bounds?(map, antinode)
    antinodes << antinode
    antinode = Point.new(antinode.y + dy, antinode.x + dx)
  end

  antinodes
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
    locations = get_antinode_locations(map, pair[0], pair[1])
    locations.each do |location|
      antinode_locations.add(location)
    end
  end
end

p antinode_locations.count
