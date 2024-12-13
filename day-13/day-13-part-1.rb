class ClawMachine
  attr_accessor :a_y_delta, :a_x_delta
  attr_accessor :b_y_delta, :b_x_delta
  attr_accessor :prize_y, :prize_x

  def initialize(a_y_delta, a_x_delta, b_y_delta, b_x_delta, prize_y, prize_x)
    @a_y_delta = a_y_delta
    @a_x_delta = a_x_delta
    @b_y_delta = b_y_delta
    @b_x_delta = b_x_delta
    @prize_y = prize_y
    @prize_x = prize_x
  end
end

def claw_machines_from_input(input)
  claw_machines = []
  input.each_slice(4).each do |claw_machine_data|
    a_x_delta, a_y_delta = claw_machine_data[0].scan(/\d+/).map(&:to_i)
    b_x_delta, b_y_delta = claw_machine_data[1].scan(/\d+/).map(&:to_i)
    prize_x, prize_y = claw_machine_data[2].scan(/\d+/).map(&:to_i)
    claw_machines << ClawMachine.new(a_y_delta, a_x_delta, b_y_delta, b_x_delta, prize_y, prize_x)
  end
  claw_machines
end

def minimum_cost_to_win(claw_machine)
  min_solve_cost = Float::INFINITY
  (0..100).each do |a|
    (0..100).each do |b|
      x = claw_machine.a_x_delta * a + claw_machine.b_x_delta * b
      y = claw_machine.a_y_delta * a + claw_machine.b_y_delta * b
      min_solve_cost = a * 3 + b if x == claw_machine.prize_x && y == claw_machine.prize_y && a * 3 + b < min_solve_cost
    end
  end

  min_solve_cost = nil if min_solve_cost == Float::INFINITY
  min_solve_cost
end

input = File.readlines("day-13/input.txt").map(&:chomp)
claw_machines = claw_machines_from_input(input)

total_minimum_solve_cost = 0
claw_machines.each do |claw_machine|
  minimum_solve_cost = minimum_cost_to_win(claw_machine)
  total_minimum_solve_cost += minimum_solve_cost unless minimum_solve_cost.nil?
end

p total_minimum_solve_cost
