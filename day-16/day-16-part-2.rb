# Strategy for part 2: Instead of instantly returning when I find the end point, continue
# searching until the next score would be greater than the end point score. This should
# populate ALL map positions that are part of a best path.
# Then, starting from the end point, walk the map BACKWARDS from the end point back to the start,
# taking a step only if the target position's score is one step worth than the current score, and
# recording each stepped-on tile as I go. Then, just count the flagged tiles.

require 'set'

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

# Breadth-first search.
def find_best_paths(map, start_position, end_point)
  queue = [start_position]
  best_path_score = nil
  while queue.size > 0
    position = queue.shift

    # Stop exploring after we've found ALL of the best paths.
    return if !best_path_score.nil? && map[position] > best_path_score

    best_path_score = map[position] if position.point.eql?(end_point)

    next_positions(position).each do |next_position|
      next unless map.key?(next_position)

      next_position_score_delta = next_position.point.eql?(position.point) ? 1000 : 1
      next if map[next_position] <= map[position] + next_position_score_delta

      # Don't turn towards a wall
      next if next_position.point.eql?(position.point) && !map.key?(ahead(next_position))

      map[next_position] = map[position] + next_position_score_delta

      queue << (next_position)
    end

    # Sort the queue by the lowest score, such that as soon as we reach the end point,
    # we're guaranteed that the score is the lowest possible to reach it (because no
    # subsequent moves could possibly have a lower score).
    queue.sort_by! { |position| map[position] }
  end

  nil
end

def backward(position)
  point_ahead = case position.direction
                when 0
                  Point.new(position.point.y + 1, position.point.x)
                when 90
                  Point.new(position.point.y, position.point.x - 1)
                when 180
                  Point.new(position.point.y - 1, position.point.x)
                else # 270
                  Point.new(position.point.y, position.point.x + 1)
                end
  Position.new(point_ahead, position.direction)
end

def backwards_next_positions(position)
  [backward(position), left(position), right(position)]
end

def positions_on_best_paths(map, end_point)
  best_path_points = Set[end_point]

  queue = []
  DIRECTIONS.each do |direction|
    queue << Position.new(end_point, direction)
  end

  while queue.size > 0
    position = queue.shift

    backwards_next_positions(position).each do |next_position|
      next unless map.key?(next_position)
      next if map[next_position] == Float::INFINITY

      next unless map[next_position] == map[position] - 1 || map[next_position] == map[position] - 1000

      best_path_points.add(next_position.point)
      queue << next_position
    end
  end

  best_path_points.count
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

find_best_paths(map, start_position, end_point)

p positions_on_best_paths(map, end_point)
