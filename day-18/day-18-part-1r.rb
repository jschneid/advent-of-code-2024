# Refactor of the Part 1 solution which stores the entire path from the start
# position to each point -- instead of just the step count to each point -- in
# preparation for the more efficient Part 2 solution.

require 'set'

class Point
  attr_reader :y, :x, :steps

  def initialize(y, x, steps)
    @y = y
    @x = x
    @steps = steps
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
    Point.new(@y + other.y, @x + other.x, @steps + other.steps)
  end
end

def next_positions(position, map_size, corrupted_bytes, visited_positions)
  deltas = [Point.new(-1, 0, 1), Point.new(1, 0, 1), Point.new(0, -1, 1), Point.new(0, 1, 1)]
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

    return position.steps if position.eql?(finish)

    next_positions(position, map_size, corrupted_bytes, visited_positions).each do |next_position|
      visited_positions.add(next_position)
      queue << next_position
    end
  end

  'No route to exit'
end

corrupted_bytes_positions = File.readlines('day-18/input.txt').map{ |line| line.split(',').map(&:to_i) }
corrupted_bytes = corrupted_bytes_positions.map { |position| Point.new(position[0], position[1], nil) }
first_n_bytes = corrupted_bytes.first(1024)

map_size = 71
finish = Point.new(map_size - 1, map_size - 1, nil)
pp shortest_path_to_exit(Point.new(0, 0, 0), finish, map_size, first_n_bytes)
