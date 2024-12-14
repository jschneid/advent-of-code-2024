class Robot
  attr_accessor :position, :velocity

  def initialize(position, velocity)
    @position = position
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

def advance_robots(robots)
  robots.each do |robot|
    robot.position.y = (robot.position.y + robot.velocity.y) % @space_height
    robot.position.x = (robot.position.x + robot.velocity.x) % @space_width
  end
end

def safety_factor(robots)
  robots_in_quadrant_count = Array.new(4, 0)
  y_divider = @space_height / 2
  x_divider = @space_width / 2
  robots.each do |robot|
    if robot.position.y < y_divider && robot.position.x > x_divider
      robots_in_quadrant_count[0] += 1
    elsif robot.position.y < y_divider && robot.position.x < x_divider
      robots_in_quadrant_count[1] += 1
    elsif robot.position.y > y_divider && robot.position.x < x_divider
      robots_in_quadrant_count[2] += 1
    elsif robot.position.y > y_divider && robot.position.x > x_divider
      robots_in_quadrant_count[3] += 1
    end
  end

  robots_in_quadrant_count.reduce(:*)
end

@space_height = 103
@space_width = 101

input_lines = File.readlines("day-14/input.txt").map(&:chomp)
robots = []
input_lines.each do |input_line|
  input_line_numbers = input_line.scan(/-?\d+/).map(&:to_i)
  position = Point.new(input_line_numbers[1], input_line_numbers[0])
  velocity = Point.new(input_line_numbers[3], input_line_numbers[2])
  robots << Robot.new(position, velocity)
end

100.times do
  advance_robots(robots)
end

p safety_factor(robots)
