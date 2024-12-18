# Optimization of the brute force solution by skipping exploring the map
# after the addition of a new corrupted byte that does not appear anywhere
# on the solution path from the previous iteration.

require 'set'

class Point
  attr_accessor :y, :x, :previous_steps

  def initialize(y, x)
    @y = y
    @x = x
    @previous_steps = Set[]
  end

  def eql?(other)
    other.is_a?(Point) && @y == other.y && @x == other.x
  end

  def hash
    @y.hash ^ @x.hash
  end

  def ==(other)
    eql?(other)
  end

  def +(other)
    Point.new(@y + other.y, @x + other.x)
  end
end

def next_positions(position, map_size, corrupted_bytes, visited_positions)
  deltas = [Point.new(-1, 0), Point.new(1, 0), Point.new(0, -1), Point.new(0, 1)]
  deltas.map { |delta| position + delta }
    .select { |next_position| next_position.y >= 0 && next_position.y < map_size && next_position.x >= 0 && next_position.x < map_size }
    .reject { |next_position| corrupted_bytes.include?(next_position) }
    .reject { |next_position| visited_positions.include?(next_position) }
end

def shortest_path_to_exit(start, finish, map_size, corrupted_bytes)
  queue = [start]
  visited_positions = Set[start]
  while queue.size > 0
    position = queue.shift

    return position.previous_steps if position.eql?(finish)

    next_positions(position, map_size, corrupted_bytes, visited_positions).each do |next_position|
      visited_positions.add(next_position)
      next_position.previous_steps = position.previous_steps.dup.add(position)
      queue << next_position
    end
  end

  'No route to exit'
end

corrupted_bytes_positions = File.readlines('day-18/input.txt').map{ |line| line.split(',').map(&:to_i) }
corrupted_bytes = corrupted_bytes_positions.map { |position| Point.new(position[1], position[0]) }

start = Point.new(0, 0)
map_size = 71
finish = Point.new(map_size - 1, map_size - 1)

corrupted_bytes_count = 1025
loop do
  print "Evaluating #{corrupted_bytes_count} corrupted bytes..."
  first_n_bytes = corrupted_bytes.first(corrupted_bytes_count)

  solution_steps = shortest_path_to_exit(start, finish, map_size, first_n_bytes)
  if solution_steps == 'No route to exit'
    pp "#{first_n_bytes.last.x},#{first_n_bytes.last.y}"
    break
  else
    puts "path found in #{solution_steps.count} steps"
  end

  corrupted_bytes_count += 1

  # Speed things along by only re-exploring if the latest new corrupted byte
  # is on the solution path from the previous iteration.
  while !solution_steps.include?corrupted_bytes[corrupted_bytes_count - 1]
    corrupted_bytes_count += 1
  end
end
