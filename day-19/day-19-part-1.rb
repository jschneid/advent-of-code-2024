require 'set'

def design_possible?(design, patterns)
  return true if design.empty?

  patterns.each do |pattern|
    if design.start_with?(pattern)
      return true if design_possible?(design[pattern.length..], patterns)
    end
  end

  false
end

input = File.readlines('day-19/input.txt').map(&:chomp)

patterns = Set[]
input[0].split(', ').each do |pattern|
  patterns.add(pattern)
end

designs = input[2..]
possible_designs = 0
designs.each do |design|
  possible_designs += 1 if design_possible?(design, patterns)
end

p possible_designs
