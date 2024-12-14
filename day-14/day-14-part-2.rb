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

  def eql?(other)
    other.is_a?(Point) && @y == other.y && @x == other.x
  end

  def hash
    @y.hash ^ @x.hash
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

# The bottom of the tree "image" will probably (hopefully) form a long horizontal line...?
def maaaaaaybe_christmas_tree?(space)
  (50...@space_height).each do |y|
    x = 0
    while x < @space_width - 10 do
      if (space.key? Point.new(y, x)) &&
         (space.key? Point.new(y, x + 1)) &&
         (space.key? Point.new(y, x + 2)) &&
         (space.key? Point.new(y, x + 3)) &&
         (space.key? Point.new(y, x + 4)) &&
         (space.key? Point.new(y, x + 5)) &&
         (space.key? Point.new(y, x + 6)) &&
         (space.key? Point.new(y, x + 7)) &&
         (space.key? Point.new(y, x + 8)) &&
         (space.key? Point.new(y, x + 9))
        puts "Hit @ #{y}, #{x}"
        return true
      end
      x += 10
    end
  end
  false
end

def print_space(space)
  (0...@space_height).each do |y|
    print "#{y.to_s.rjust(3, ' ')} "
    (0...@space_width).each do |x|
      if space.key? Point.new(y, x)
        print '*'
      else
        print '.'
      end
    end
    puts
  end
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

i = 0
loop do
  i += 1
  space = advance_robots(space)
  if maaaaaaybe_christmas_tree?(space)
    puts "Seconds elapsed: #{i}"
    print_space(space)
    break
  end
end

