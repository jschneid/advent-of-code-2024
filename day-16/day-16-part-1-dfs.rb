# This is a "failed" attempt at implementing 2024.16.1 via depth-first search.
# It actually DOES return the correct answer eventually, but is highly inefficient
# for the real problem input (with the large map), because it retreads a lot of the
# same paths many times (even with logic in place to bail out of a given path walk
# if we'd previously reached that position (point + direction) with a lower score).

# Due to Ruby stack size limitations, I needed to do two things at the terminal
# to get this to even run successfully on my Mac, BOTH of which were necessary:
#
# (1) Increase the system stack size limit (for the current terminal session) to the max:
# `ulimit -s 65520`
# (the default was 8176)
#
# (2) Increase the Ruby VM's stack size to a huge value:
# `export RUBY_THREAD_VM_STACK_SIZE=50000000`
#
# Once those were in place, I could run this program via the terminal (NOT RubyMine).

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

class Position
  attr_accessor :point, :direction

  def initialize(point, direction)
    @point = point
    @direction = direction
  end

  def ==(other)
    eql?(other)
  end

  def eql?(other)
    other.is_a?(Position) && @point.eql?(other.point) && @direction == other.direction
  end

  def hash
    @point.hash ^ @direction.hash
  end
end

DIRECTIONS = [0, 90, 180, 270].freeze

def ahead(position)
  point_ahead = case position.direction
                when 0
                  Point.new(position.point.y - 1, position.point.x)
                when 90
                  Point.new(position.point.y, position.point.x + 1)
                when 180
                  Point.new(position.point.y + 1, position.point.x)
                else # 270
                  Point.new(position.point.y, position.point.x - 1)
                end
  Position.new(point_ahead, position.direction)
end

def left(position)
  Position.new(position.point, (position.direction - 90) % 360)
end

def right(position)
  Position.new(position.point, (position.direction + 90) % 360)
end

def next_positions(position)
  [ahead(position), left(position), right(position)]
end

def explore_map(map, start_position)
  next_positions(start_position).each do |position|
    next unless map.key?(position)

    next_position_score_delta = position.point.eql?(start_position.point) ? 1000 : 1
    next if map[position] <= map[start_position] + next_position_score_delta

    # Don't turn towards a wall
    next if position.point.eql?(start_position.point) && !map.key?(ahead(position))

    map[position] = map[start_position] + next_position_score_delta
    explore_map(map, position)
  end
end

# Hash map of positions to lowest score to reach that position
map = {}

start_position = nil
end_point = nil
File.readlines('day-16/input.txt').map(&:chomp).each_with_index do |line, y|
  line.each_char.with_index do |char, x|
    next if char == '#'

    point = Point.new(y, x)
    DIRECTIONS.each do |direction|
      position = Position.new(point, direction)
      if char == 'S' && direction == 90
        start_position = position
        map[position] = 0
      else
        map[position] = Float::INFINITY
      end
    end
    if char == 'E'
      end_point = point
    end
  end
end

explore_map(map, start_position)

pp map.select { |position, _| position.point.eql?(end_point) }.values.min
