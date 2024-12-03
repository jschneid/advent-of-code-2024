input = File.read("day-03/input.txt")
mul_instructions = input.scan(/mul\(\d+,\d+\)/)

sum_of_products = 0
mul_instructions.each do |mul_instruction|
  nums = mul_instruction.scan(/\d+/)
  sum_of_products += nums[0].to_i * nums[1].to_i
end

p sum_of_products
