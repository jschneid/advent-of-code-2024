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

def facing_character(facing)
  case facing
  when :north
    '^'
  when :east
    '>'
  when :south
    'v'
  else # :west
    '<'
  end
end

def clone(map)
  Marshal.load(Marshal.dump(map))
end

def rounds_results_in_cycle?(map, guard_position, guard_facing, max_y, max_x)
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

    return false unless in_bounds?(ahead_position, max_y, max_x)

    return true if map[ahead_position.y][ahead_position.x] == facing_character(guard_facing)

    if map[ahead_position.y][ahead_position.x] == '#'
      guard_facing = turn_right(guard_facing)
    else
      guard_position = ahead_position
      map[guard_position.y][guard_position.x] = facing_character(guard_facing)
    end
  end
end

map = File.readlines("day-06/input.txt").map(&:chomp)
guard_facing = :north

max_y = map.length - 1
max_x = map[0].length - 1

guard_position = starting_location(map)

map[guard_position.y][guard_position.x] = '^'

# I could pick points to place the obstruction only along the guard's
# unobstructed path. But let's just brute force place them everywhere,
# because that requires somewhat less code (even if it's less efficient
# in terms of runtime!).
obstruction_positions_resulting_in_cycle = 0
map.each_with_index do |row, y|
  row.each_char.each_with_index do |char, x|
    next if guard_position.y == y && guard_position.x == x
    next if char == '#'

    map_clone = clone(map)
    map_clone[y][x] = '#'

    obstruction_positions_resulting_in_cycle += 1 if rounds_results_in_cycle?(map_clone, guard_position, guard_facing, max_y, max_x)
  end
end

p obstruction_positions_resulting_in_cycle
