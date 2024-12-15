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
  rank_positions = moving_position_stack.pop

  loop do
    rank_positions.each do |position|
      warehouse[position + delta] = warehouse[position]
      warehouse[position] = '.'
    end

    break if moving_position_stack.empty?

    rank_positions = moving_position_stack.pop
  end
end

def execute_move(delta, warehouse, robot_position)
  # Set up a list of objects in each "rank" (row or column) being pushed by the robot.
  moving_position_stack = [[robot_position]]

  current_rank_positions = [robot_position]
  loop do
    # Set next_rank_positions to the positions in front of each object that is being moved.
    next_rank_positions = []
    current_rank_positions.each do |current_rank_position|
      next_rank_position = current_rank_position + delta

      # If we're moving vertically (north or south), and there's a box in front of us,
      # then both halves of the box will move.
      if warehouse[next_rank_position] == '[' && delta.y != 0
        other_half_of_box_position = next_rank_position + Point.new(0, 1)
        next_rank_positions << other_half_of_box_position
      elsif warehouse[next_rank_position] == ']' && delta.y != 0
        other_half_of_box_position = next_rank_position + Point.new(0, -1)
        next_rank_positions << other_half_of_box_position
      end

      next_rank_positions << next_rank_position
    end

    # Deduplicate the positions in next_rank_positions, e.g. when a box is being pushed
    # vertically into another box. This is required to avoid moving those positions twice
    # (and consequently overwriting a box being moved with the empty air that was left
    # behind on the 2nd copy of the same move).
    next_rank_positions = next_rank_positions.uniq

    if next_rank_positions.any? { |next_rank_position| warehouse[next_rank_position] == '#' }
      # Something that we're moving hit a wall: Don't move anything.
      return robot_position
    elsif next_rank_positions.all? { |next_rank_position| warehouse[next_rank_position] == '.' }
      # Everything that we're moving has empty space in front of it! Proceed with the move.
      move_stack(moving_position_stack, warehouse, delta)
      return robot_position + delta
    else
      # Exclude empty space positions, to avoid having empty air ending up pushing boxes! For example,
      # the topmost box must NOT move in this situation where the robot is about to move north -- the
      # empty air at y=2, x=1 must not push the box at y=1, x=1:
      #
      #   0123
      # 0 ....
      # 1 []..
      # 2 ..[]
      # 3 .[].
      # 4 .@..
      next_rank_positions = next_rank_positions.reject { |next_rank_position| warehouse[next_rank_position] == '.' }

      moving_position_stack.push next_rank_positions
      current_rank_positions = next_rank_positions
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
    point_l = Point.new(y, x * 2)
    point_r = Point.new(y, x * 2 + 1)

    if char == '#'
      warehouse[point_l] = '#'
      warehouse[point_r] = '#'
    elsif char == 'O'
      warehouse[point_l] = '['
      warehouse[point_r] = ']'
    elsif char == '.'
      warehouse[point_l] = '.'
      warehouse[point_r] = '.'
    else # char == '@'
      warehouse[point_l] = '@'
      warehouse[point_r] = '.'
      robot_position = point_l
    end
  end
end

directions.each_char do |move|
  delta = move_char_to_delta(move)
  robot_position = execute_move(delta, warehouse, robot_position)
end

total_box_gps = 0
warehouse.each do |point, object|
  if object == '['
    total_box_gps += point.gps_coordinate
  end
end

pp total_box_gps
