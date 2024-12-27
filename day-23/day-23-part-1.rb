require 'set'

input = File.readlines('day-23/input.txt').map(&:chomp)

computers = Hash.new { |h, k| h[k] = Set.new }
input.each do |line|
  computer_names = line.split('-')
  computers[computer_names[0]].add(computer_names[1])
  computers[computer_names[1]].add(computer_names[0])
end

triangles = Set[]
computers.each do |computer, connected_computers|
  connected_computers.to_a.combination(2).each do |combination|
    triangles.add(Set[computer, combination[0], combination[1]]) if computers[combination[0]].include?(combination[1])
  end
end

pp triangles.select { |triangle| triangle.any? { |computer| computer[0] == 't'} }.size
