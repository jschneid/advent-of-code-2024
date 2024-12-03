input = File.read("day-03/input.txt")
instructions = input.scan(/mul\(\d+,\d+\)|do\(\)|don't\(\)/)

sum_of_products = 0
multiplications_enabled = true
instructions.each do |instruction|
  if instruction == 'do()'
    multiplications_enabled = true
  elsif instruction == "don't()"
    multiplications_enabled = false
  elsif multiplications_enabled
    nums = instruction.scan(/\d+/)
    sum_of_products += nums[0].to_i * nums[1].to_i
  end
end

p sum_of_products
