def can_be_valid?(test_value, equation)
  max_calibration_map_trinary = 3 ** (equation.length - 1) - 1

  (0..max_calibration_map_trinary).each do |operator_pattern_number|
    operator_pattern = operator_pattern_number.to_s(3).rjust(equation.length - 1, '0')

    result = equation.first
    (1..(equation.length - 1)).each do |equation_index|
      if operator_pattern[equation_index - 1] == '0'
        result += equation[equation_index]
      elsif operator_pattern[equation_index - 1] == '1'
        result *= equation[equation_index]
      else
        result = (result.to_s + equation[equation_index].to_s).to_i
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
