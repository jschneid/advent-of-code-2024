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

  def +(other)
    Point.new(@y + other.y, @x + other.x)
  end

  def gps_coordinate
    100 * y + x
  end
end

def move_char_to_delta(move)
  case move
  when '^'
    Point.new(-1, 0)
  when 'v'
    Point.new(1, 0)
  when '<'
    Point.new(0, -1)
  else # 'E'
    Point.new(0, 1)
  end
end

def move_stack(moving_position_stack, warehouse, delta)
  position = moving_position_stack.pop

  loop do
    warehouse[position + delta] = warehouse[position]

    break if moving_position_stack.empty?

    position = moving_position_stack.pop
  end

  warehouse[position] = '.'
end

def execute_move(delta, warehouse, robot_position)
  moving_position_stack = [robot_position]
  position = robot_position
  loop do
    next_position = position + delta
    next_position_object = warehouse[next_position]

    if next_position_object == '#'
      return robot_position
    elsif next_position_object == 'O'
      moving_position_stack.push next_position
      position = next_position
    else # next_position_object == '.'
      move_stack(moving_position_stack, warehouse, delta)
      return robot_position + delta
    end
  end
end

input = File.readlines('day-15/input.txt').map(&:chomp)
split_input = input.slice_before('').to_a
map = split_input[0]
directions = split_input[1].join

warehouse = {}
robot_position = nil
map.each_with_index do |line, y|
  line.each_char.each_with_index do |char, x|
    point = Point.new(y, x)
    warehouse[point] = char
    robot_position = point if char == '@'
  end
end

directions.each_char do |move|
  delta = move_char_to_delta(move)
  robot_position = execute_move(delta, warehouse, robot_position)
end

total_box_gps = 0
warehouse.each do |point, object|
  if object == 'O'
    total_box_gps += point.gps_coordinate
  end
end

pp total_box_gps
