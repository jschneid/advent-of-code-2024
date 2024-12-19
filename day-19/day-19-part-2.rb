require 'set'

def possible_designs(design, patterns, memoized_possible_designs)
  return 1 if design.empty?

  # The impact of this memoization is wild. It reduces the program's runtime from
  # multiple days to about a second.
  return memoized_possible_designs[design] if memoized_possible_designs.key?(design)

  possibilities = 0
  patterns.each do |pattern|
    if design.start_with?(pattern)
      possibilities += possible_designs(design[pattern.length..], patterns, memoized_possible_designs)
    end
  end

  memoized_possible_designs[design] = possibilities

  possibilities
end

input = File.readlines('day-19/input.txt').map(&:chomp)

patterns = Set[]
input[0].split(', ').each do |pattern|
  patterns.add(pattern)
end

designs = input[2..]
possibilities = 0
memoized_possible_designs = {}
designs.each do |design|
  possibilities += possible_designs(design, patterns, memoized_possible_designs)
end

p possibilities
