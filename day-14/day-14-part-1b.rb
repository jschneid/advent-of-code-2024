# This is a refactoring of Part 1 with faster robot position access in preparation for Part 2.
# (It serves as a "unit test" of sorts: Running this should produce the same result as the
# original code for Part 1.)

class Robot
  attr_accessor :velocity

  def initialize(velocity)
    @velocity = velocity
  end
end

class Point
  attr_accessor :y, :x

  def initialize(y, x)
    @y = y
    @x = x
  end
end

def advance_robots(space)
  next_space = {}
  space.each do |position, robots|
    robots.each do |robot|
      next_position = Point.new(
        (position.y + robot.velocity.y) % @space_height,
        (position.x + robot.velocity.x) % @space_width
      )
      next_space[next_position] ||= []
      next_space[next_position] << robot
    end
  end
  next_space
end

def safety_factor(space)
  robots_in_quadrant_count = Array.new(4, 0)
  y_divider = @space_height / 2
  x_divider = @space_width / 2
  space.each do |position, robots|
    if position.y < y_divider && position.x > x_divider
      robots_in_quadrant_count[0] += robots.count
    elsif position.y < y_divider && position.x < x_divider
      robots_in_quadrant_count[1] += robots.count
    elsif position.y > y_divider && position.x < x_divider
      robots_in_quadrant_count[2] += robots.count
    elsif position.y > y_divider && position.x > x_divider
      robots_in_quadrant_count[3] += robots.count
    end
  end

  robots_in_quadrant_count.reduce(:*)
end

@space_height = 103
@space_width = 101

space = {}

input_lines = File.readlines("day-14/input.txt").map(&:chomp)
input_lines.each do |input_line|
  input_line_numbers = input_line.scan(/-?\d+/).map(&:to_i)
  position = Point.new(input_line_numbers[1], input_line_numbers[0])
  velocity = Point.new(input_line_numbers[3], input_line_numbers[2])

  space[position] ||= []
  space[position] << Robot.new(velocity)
end

100.times do
  space = advance_robots(space)
end

p safety_factor(space)
