def adv(operand)
  @register_a = @register_a / 2**combo(operand)
end

def bxl(operand)
  @register_b = @register_b ^ operand
end

def bst(operand)
  @register_b = combo(operand) % 8
end

def jnz(operand)
  return if @register_a.zero?

  @instruction_pointer = operand
  @instruction_pointer -= 2 # Undo the subsequent +2 increment
end

def bxc
  @register_b = @register_b ^ @register_c
end

def out(operand)
  @output << combo(operand) % 8
end

def bdv(operand)
  @register_b = @register_a / 2**combo(operand)
end

def cdv(operand)
  @register_c = @register_a / 2**combo(operand)
end

def run_instruction(opcode, operand)
  case opcode
  when 0
    adv(operand)
  when 1
    bxl(operand)
  when 2
    bst(operand)
  when 3
    jnz(operand)
  when 4
    bxc
  when 5
    out(operand)
  when 6
    bdv(operand)
  when 7
    cdv(operand)
  else
    raise "Invalid instruction: #{opcode}, #{operand}"
  end
end

def combo(operand)
  case operand
  when 0
    0
  when 1
    1
  when 2
    2
  when 3
    3
  when 4
    @register_a
  when 5
    @register_b
  when 6
    @register_c
  else
    raise "Invalid combo operand value: #{operand}"
  end
end

input = File.readlines("day-17/input.txt").map(&:chomp)

@register_a = 0
loop do

@register_a += 1
@register_b = input[1][12..].to_i
@register_c = input[2][12..].to_i

@instruction_pointer = 0
@output = []
program = input[4].scan(/\d+/).map(&:to_i)

while @instruction_pointer < program.size
  opcode = program[@instruction_pointer]
  operand = program[@instruction_pointer + 1]
  run_instruction(opcode, operand)
  @instruction_pointer += 2
end

puts @output.join(',')
