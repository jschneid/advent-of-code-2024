require 'set'

class Gate
  attr_accessor :input_wires, :operation, :output_wire

  def initialize(input_wires, operation, output_wire, wires)
    @input_wires = input_wires
    @operation = operation
    @output_wire = output_wire
    @wires = wires
  end

  def execute!
    return unless @wires[@output_wire].nil?
    return if @wires[@input_wires[0]].nil?
    return if @wires[@input_wires[1]].nil?

    if @operation == 'AND'
      @wires[output_wire] = @wires[@input_wires[0]] & @wires[@input_wires[1]]
    elsif @operation == 'OR'
      @wires[output_wire] = @wires[@input_wires[0]] | @wires[@input_wires[1]]
    else # XOR
      @wires[output_wire] = @wires[@input_wires[0]] ^ @wires[@input_wires[1]]
    end
  end
end

def execute(gates)
  while @wires.select { |key, _| key[0] == 'z' }.any? { |_, value| value.nil? }
    gates.each(&:execute!)
  end

  result = 0
  @wires.keys.select { |key| key[0] == 'z' }.sort.reverse_each do |key|
    result <<= 1
    result += @wires[key]
  end
  result
end

lines = File.readlines('day-24/input.txt').map(&:chomp)

@wires = Hash.new(nil)
gates = Set[]
lines.reverse_each do |line|
  if line.include?('->')
    split_line = line.split(' ')
    @wires[split_line[0]] = nil
    @wires[split_line[2]] = nil
    @wires[split_line[4]] = nil
    gates.add(Gate.new([split_line[0], split_line[2]], split_line[1], split_line[4], @wires))
  elsif line.include?(':')
    split_line = line.split(': ')
    @wires[split_line[0]] = split_line[1].to_i
  end
end

pp execute(gates)

