require 'set'

def largest_group(computers, computer, connected_computers)
  connected_computers.count.downto(3) do |group_size|
    subset = connected_computers.to_a.combination(group_size)
    subset.each do |group|
      return group << computer if group.all? do |member|
        others = group - [member]
        others.all? { |other| computers[member].include?(other) }
      end
    end
  end
  nil
end

input = File.readlines('day-23/input.txt').map(&:chomp)

computers = Hash.new { |h, k| h[k] = Set.new }
input.each do |line|
  computer_names = line.split('-')
  computers[computer_names[0]].add(computer_names[1])
  computers[computer_names[1]].add(computer_names[0])
end

large_groups = Set[]
computers.each do |computer, connected_computers|
  group = largest_group(computers, computer, connected_computers)
  large_groups.add(group.sort) if group
end

pp large_groups.to_a.max_by(&:size).join(',')
