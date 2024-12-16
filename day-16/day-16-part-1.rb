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
def lowest_score_to_end_point(map, start_position, end_point)
  queue = [start_position]
  while queue.size > 0
    position = queue.shift

    if position.point.eql?(end_point)
      return map[position]
    end

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

pp lowest_score_to_end_point(map, start_position, end_point)
