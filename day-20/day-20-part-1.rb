# Assumptions:
#
# (1) Even though the problem statement says that "a program may disable collision for up to 2 picoseconds",
# only ONE wall segment may be passed through.
#
# (2) A cheat will always be a straight pass-through -- not cutting a corner. That is, there will be no map
# sections like this:
# #.
# .#

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

  def ==(other)
    eql?(other)
  end

  def +(other)
    Point.new(@y + other.y, @x + other.x)
  end
end

# Walk the (single-path) map, and set the map_steps for each point as we go.
# When we're done, any map position that doesn't have an entry in map_steps
# is a wall.
def assign_position_costs(map, start_point)
  map_steps = { start_point => 0 }
  directions = [Point.new(-1, 0), Point.new(1, 0), Point.new(0, -1), Point.new(0, 1)]
  point = start_point
  reached_the_end = false

  until reached_the_end
    reached_the_end = true

    directions.each do |step|
      next_point = point + step
      next if map[next_point.y][next_point.x] == '#'

      # If we already have a step count for a point, then we already visited it.
      next if map_steps.key?(next_point)

      map_steps[next_point] = map_steps[point] + 1
      point = next_point
      reached_the_end = false
      break
    end
  end

  map_steps
end

# For each wall, if there's open space on opposite sides of the wall (either vertically or
# horizontally), then the time saved by cheating will be the difference in steps between those
# two open spaces, minus 2 (the time it takes to walk through the wall).
def cheats_time_saved(map, map_steps)
  cheats_time_saved = []
  map.each_index do |y|
    map[y].each_char.with_index do |char, x|
      next unless char == '#'

      if map_steps.key?(Point.new(y - 1, x)) && map_steps.key?(Point.new(y + 1, x))
        cheats_time_saved << (map_steps[Point.new(y - 1, x)] - map_steps[Point.new(y + 1, x)]).abs - 2
      elsif map_steps.key?(Point.new(y, x - 1)) && map_steps.key?(Point.new(y, x + 1))
        cheats_time_saved << (map_steps[Point.new(y, x - 1)] - map_steps[Point.new(y, x + 1)]).abs - 2
      end
    end
  end
  cheats_time_saved
end

start_point = nil
map = File.readlines('day-20/input.txt').map(&:chomp)
map.each_with_index do |line, y|
  line.each_char.with_index do |char, x|
    start_point = Point.new(y, x) if char == 'S'
  end
end

map_steps = assign_position_costs(map, start_point)

times_saved = cheats_time_saved(map, map_steps)
p times_saved.select { |time_saved| time_saved >= 100 }.count
