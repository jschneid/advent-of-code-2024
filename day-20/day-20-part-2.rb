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

# The instructions for this problem are ambiguous in that they don't specify whether a given cheat
# needs to actually be strictly "advantageous" to be counted. For example, consider the following map:
#
# #########################
# #S......................#
# #######################.#
# #.......................#
# #.#######################
# #E#
# ###
#
# It turns out that a cheat from that start point all the way to the end point -- with a step distance of 4 --
# IS supposed to be counted as a possible cheat, even though the last 2 steps of that distance (after passing
# through the long horizontal wall; and then continuing on to unnecessarily "cheat" through 2 more steps of open
# space) are only partially really "cheating".
#
# This does actually make the code simpler, as we don't need to do any kind of check that a cheat
# begins with entering a wall, or ends with emerging from a wall. (Including figuring out how to deal with
# possible cases where the endpoint might be reachable from one direction (e.g. north) through a wall, but
# reachable from the other direction (e.g. west) through an open space.)
MAX_CHEAT_DISTANCE = 20
def cheat_destinations(start_point, map_steps)
  destinations = []
  ((start_point.y - MAX_CHEAT_DISTANCE)..(start_point.y + MAX_CHEAT_DISTANCE)).each do |y|
    ((start_point.x - MAX_CHEAT_DISTANCE)..(start_point.x + MAX_CHEAT_DISTANCE)).each do |x|
      next if (y - start_point.y).abs + (x - start_point.x).abs > MAX_CHEAT_DISTANCE
      next if y == start_point.y && x == start_point.x

      destination = Point.new(y, x)

      next unless map_steps.key?(destination)
      next if map_steps[start_point] > map_steps[destination]

      destinations << destination
    end
  end
  destinations
end

def cheats_time_saved(map, map_steps)
  cheats_time_saved = Hash.new(0)
  map.each_index do |y|
    map[y].each_char.with_index do |char, x|
      next unless char != '#'

      start_point = Point.new(y, x)
      destinations = cheat_destinations(start_point, map_steps)
      destinations.each do |destination|
        time_saved = (map_steps[destination] - map_steps[start_point]) - (start_point.y - destination.y).abs - (start_point.x - destination.x).abs
        cheats_time_saved[time_saved] += 1 if time_saved.positive?
      end
    end
  end
  cheats_time_saved
end

def find_start_point(map)
  map.each_with_index do |line, y|
    line.each_char.with_index do |char, x|
      return Point.new(y, x) if char == 'S'
    end
  end
end

map = File.readlines('day-20/input.txt').map(&:chomp)
start_point = find_start_point(map)
map_steps = assign_position_costs(map, start_point)

times_saved = cheats_time_saved(map, map_steps)

p times_saved.select { |time_saved, _| time_saved >= 100 }.values.sum
