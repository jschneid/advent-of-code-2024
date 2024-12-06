class Point
  attr_accessor :y, :x

  def initialize(y, x)
    @y = y
    @x = x
  end
end

def starting_location(map)
  map.each_with_index do |line, y|
    line.each_char.each_with_index do |char, x|
      return Point.new(y, x) if char == '^'
    end
  end
end

def in_bounds?(position, max_y, max_x)
  return false if position.y < 0 || position.y > max_y
  return false if position.x < 0 || position.x > max_x
  true
end

def turn_right(facing)
  case facing
  when :north
    :east
  when :east
    :south
  when :south
    :west
  else # :west
    :north
  end
end

def perform_rounds(map, guard_position, guard_facing, max_y, max_x)
  loop do
    case guard_facing
    when :north
      ahead_position = Point.new(guard_position.y - 1, guard_position.x)
    when :east
      ahead_position = Point.new(guard_position.y, guard_position.x + 1)
    when :south
      ahead_position = Point.new(guard_position.y + 1, guard_position.x)
    when :west
      ahead_position = Point.new(guard_position.y, guard_position.x - 1)
    end

    return unless in_bounds?(ahead_position, max_y, max_x)

    if map[ahead_position.y][ahead_position.x] == '#'
      guard_facing = turn_right(guard_facing)
    else
      guard_position = ahead_position
      map[guard_position.y][guard_position.x] = 'X'
    end
  end
end

map = File.readlines("day-06/input.txt").map(&:chomp)
guard_facing = :north

max_y = map.length - 1
max_x = map[0].length - 1

guard_position = starting_location(map)
map[guard_position.y][guard_position.x] = 'X'

perform_rounds(map, guard_position, guard_facing, max_y, max_x)

pp map.map { |line| line.count('X') }.sum
