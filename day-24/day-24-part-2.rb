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

def ancestor_wires(gate, gates_by_output_wire)
  ancestors = []

  gate.input_wires.each do |wire|
    ancestors << wire
    ancestors += ancestor_wires(gates_by_output_wire[wire], gates_by_output_wire) if gates_by_output_wire.key?(wire)
  end

  ancestors.uniq
end

def wires_binary_value(prefix, wires)
  value = 0
  place = 0
  loop do
    wire_id = "#{prefix}#{format('%02d', place)}"
    return value unless wires.key?(wire_id)

    value += (wires[wire_id] << place)
    place += 1
  end
end

def expected_binary_sum(addend_x, addend_y)
  (addend_x + addend_y).to_s(2)
end

lines = File.readlines('day-24/input.txt').map(&:chomp)

gates_by_output_wire = {}

@wires = Hash.new(nil)
gates = Set[]
lines.reverse_each do |line|
  if line.include?('->')
    split_line = line.split(' ')
    @wires[split_line[0]] = nil
    @wires[split_line[2]] = nil
    @wires[split_line[4]] = nil
    gate = Gate.new([split_line[0], split_line[2]], split_line[1], split_line[4], @wires)
    gates.add(gate)
    gates_by_output_wire[split_line[4]] = gate
  elsif line.include?(':')
    split_line = line.split(': ')
    @wires[split_line[0]] = split_line[1].to_i
  end
end

execute(gates)

# Patterns in my input:
# X0 AND Y0 => A(kqn)
# X1 XOR Y1 => B(knr)
# A XOR B => Z1
# A AND B => C(fhg)

# C OR D => E(mkg)
# X1 AND Y1 => D(stk)
# X2 XOR Y2 => F(sbv)
# E XOR F => Z2
# E AND F => G(wwd)

# G OR H => I(gfq)
# X2 AND Y2 => H(mrq)
# X3 XOR Y3 => J(kfr)
# I XOR J => Z3
# I AND J => K(fdc)

# I'm assuming that this observed pattern is how the machine is "supposed" to be built, i.e. that there
# are no variances in the design as the bit count increases. (And more generally, that the machine isn't
# "spaghetti code".)

# (Therefore, this is not a "general solution" to the problem statement. But it does solve the problem
# for my input, at least!)

# So, every "level" except 0, 1, and the final one should have a pattern of 5 gates like the above two blocks
# (X==2 in this example):
#
# XN XOR YN => F
# E XOR F => ZN
# E AND F => G
# XN AND YN => H
# G OR H => I
# X(N+1) XOR Y(N+1) => J
# I XOR J => Z(N+1)

swap_gates = []
max_z = @wires.keys.select { |key| key[0] == 'z' }.map { |key| key[1..-1].to_i }.max
(2..(max_z - 2)).each do |bit|
  xn = "x#{format('%02d', bit)}"
  yn = "y#{format('%02d', bit)}"
  zn = "z#{format('%02d', bit)}"
  xn_plus_one = "x#{format('%02d', bit + 1)}"
  yn_plus_one = "y#{format('%02d', bit + 1)}"
  zn_plus_one = "z#{format('%02d', bit + 1)}"

  gate_f = gates.find { |gate| gate.input_wires.tally == [xn, yn].tally && gate.operation == 'XOR' }

  gate_z_n = gates.find { |gate| gate.input_wires.include?(gate_f.output_wire) && gate.operation == 'XOR' && gate.output_wire == zn }
  next if gate_z_n.nil?

  gate_g = gates.find { |gate| gate.input_wires.include?(gate_f.output_wire) && gate.operation == 'AND' }
  gate_h = gates.find { |gate| gate.input_wires.tally == [xn, yn].tally && gate.operation == 'AND' }
  gate_i = gates.find { |gate| gate.input_wires.tally == [gate_g.output_wire, gate_h.output_wire].tally && gate.operation == 'OR' }
  gate_j = gates.find { |gate| gate.input_wires.tally == [xn_plus_one, yn_plus_one].tally && gate.operation == 'XOR' }

  gate_z_n_plus_one = gates.find { |gate| gate.input_wires.tally == [gate_i.output_wire, gate_j.output_wire].tally && gate.operation == 'XOR' && gate.output_wire == zn_plus_one }
  next unless gate_z_n_plus_one.nil?

  swap_gate = gates.find { |gate| gate.input_wires.tally == [gate_i.output_wire, gate_j.output_wire].tally && gate.operation == 'XOR' }
  if swap_gate
    swap_gates << swap_gate.output_wire
    swap_gates << zn_plus_one
  else
    swap_gates << gate_j.output_wire
    other_swap_gate = gates.find { |gate| gate.input_wires.include?(gate_i.output_wire) && gate.operation == 'XOR' }
    swap_gates << other_swap_gate.input_wires.find { |wire| wire != gate_i.output_wire }
  end
end

p swap_gates.sort.join(',')
