def adv(operand)
  @register_a = @register_a / (2**combo(operand))
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
  @register_b = @register_a / (2**combo(operand))
end

def cdv(operand)
  @register_c = @register_a / (2**combo(operand))
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

def initialize_vm(input, initial_register_a)
  @register_a = initial_register_a
  @register_b = input[1][12..].to_i
  @register_c = input[2][12..].to_i
  @instruction_pointer = 0
  @output = []
end

# A brute force approach of checking every single possible starting value of A
# starting with 0, to see if it produced output equal to the program, turned
# out to be far too slow.
#
# Reverse-engineering the program from my specific input, I found that it did,
# in summary:
# 1. Perform several math operations on A such that a value (0..7) gets output
# 2. Divide A by 8
# 3. Repeat both of the above steps until A == 0, then end
#
# Optimized strategy:
# 1. "Work backwards" by starting with A = 0, then incrementing A by 1
# until the LAST element of the program is produced.
# 2. Then, multiply that successful run's starting A by 8 (to reverse the
# aforementioned "Divide A by 8") and repeat until the program outputs
# the last TWO last program elements.
# 3. Keep repeating the previous step until the entire program is output.

initial_register_a = 0
input = File.readlines("day-17/input.txt").map(&:chomp)
initialize_vm(input, initial_register_a)

program = input[4].scan(/\d+/).map(&:to_i)

target = [program.last]
next_target_index = program.length - 2

loop do
  opcode = program[@instruction_pointer]
  operand = program[@instruction_pointer + 1]

  run_instruction(opcode, operand)
  @instruction_pointer += 2

  if @output.eql?(target)
    p "Starting A of #{initial_register_a} produces #{target}"

    break if next_target_index.negative?

    initial_register_a *= 8
    initialize_vm(input, initial_register_a)

    target.unshift(program[next_target_index])
    next_target_index -= 1
  elsif @instruction_pointer >= program.size
    initial_register_a += 1
    initialize_vm(input, initial_register_a)
  end
end
