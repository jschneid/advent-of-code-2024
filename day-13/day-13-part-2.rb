require 'matrix'

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
    prize_x, prize_y = claw_machine_data[2].scan(/\d+/).map(&:to_i).map{ |n| n + 10000000000000 }

    claw_machines << ClawMachine.new(a_y_delta, a_x_delta, b_y_delta, b_x_delta, prize_y, prize_x)
  end
  claw_machines
end

def minimum_cost_to_win(claw_machine)
  # This is some code that I will admit I don't understand the math behind!, other than that it works
  # to solve a system of equations like (for the first example from the problem statement):
  #
  # 94a + 22b = 8400
  # 34a + 67b = 5400
  # => a = 80, b = 40
  #
  # I was concerned that there might be claw machines with multiple possible solutions such that
  # it would be necessary to pick from among multiple possible solutions to find the one with
  # the minimum cost, such as:
  #
  # Button A: X+4, Y+4
  # Button B: X+1, Y+1
  # Prize: X=8, Y=8
  #
  # However, neither the problem statement's sample inputs nor my AoC inputs had such a machine
  # (as evidenced by this code generating the correct solution for Part 2), so leaving it as-is!
  coefficients = Matrix[
    [claw_machine.a_y_delta, claw_machine.b_y_delta],
    [claw_machine.a_x_delta, claw_machine.b_x_delta],
  ]

  constants = Vector[claw_machine.prize_y, claw_machine.prize_x]

  solution = coefficients.inverse * constants
  a_presses, b_presses = solution.to_a

  # A denominator value for either a or b of other than 1 indicates that the only solution
  # would involve a fractional count of button presses, which obviously we won't consider.
  return a_presses.numerator * 3 + b_presses.numerator if a_presses.denominator == 1 && b_presses.denominator == 1

  nil
end

input = File.readlines("day-13/input.txt").map(&:chomp)
claw_machines = claw_machines_from_input(input)

total_minimum_solve_cost = 0
claw_machines.each do |claw_machine|
  minimum_solve_cost = minimum_cost_to_win(claw_machine)
  total_minimum_solve_cost += minimum_solve_cost unless minimum_solve_cost.nil?
end

p total_minimum_solve_cost
