def can_be_valid?(test_value, equation)
  # Get the max binary integer value of length 1 less than the equation operand count.
  # For example, for the equation "10 20 30 40", this would be 7 (binary "111").
  max_calibration_map_binary = 2 ** (equation.length - 1) - 1

  # We'll use each binary value between 0 and max_calibration_map_binary as the set of all possible
  # combinations of operators, with 0 being "+" and 1 being "*". Continuing the above example, the
  # first value, binary "000", results in the equation "10 + 20 + 30 + 40". The next value, binary
  # "001", results in the equation "10 + 20 + 30 * 40". And so on, through the final binary value
  # "111" resulting in the equation "10 * 20 * 30 * 40".
  (0..max_calibration_map_binary).each do |operator_pattern_number|
    operator_pattern = operator_pattern_number.to_s(2).rjust(equation.length - 1, '0')

    result = equation.first
    (1..(equation.length - 1)).each do |equation_index|
      if operator_pattern[equation_index - 1] == '0'
        result += equation[equation_index]
      else
        result *= equation[equation_index]
      end
    end
    return true if result == test_value
  end

  false
end

calibration_equations = File.readlines("day-07/input.txt").map(&:chomp)
split_equations = calibration_equations.map { |equation| equation.split(':') }
test_values = split_equations.map { |equation| equation[0].to_i }
equations = split_equations.map { |equation| equation[1].split.map(&:to_i) }

total_calibration_result = 0
test_values.each_with_index do |test_value, index|
  total_calibration_result += test_value if can_be_valid?(test_value, equations[index])
end
p total_calibration_result
