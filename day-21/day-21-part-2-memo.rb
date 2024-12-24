# Failed implementation attempt which tried to speed up runtime via memoization of intermediate results.

require 'set'

class LengthSortedHash
  def initialize
    @hash = {}
    @sorted_keys = []
  end

  def [](key)
    @hash[key]
  end

  def []=(key, value)
    @hash[key] = value
    insert_sorted_key(key)
  end

  def each
    @sorted_keys.each do |key|
      yield key, @hash[key]
    end
  end

  private

  def insert_sorted_key(key)
    return if @sorted_keys.include?(key)

    index = @sorted_keys.bsearch_index { |k| key.length > k.length } || @sorted_keys.size
    @sorted_keys.insert(index, key)
  end
end

def numeric_keypad_best_path(from, to)
  case from
  when 'A'
    case to
    when 'A'; ''
    when '0'; '<'
    when '1'; '^<<'
    when '2'; '<^'
    when '3'; '^'
    when '4'; '^^<<'
    when '5'; '<^^'
    when '6'; '^^'
    when '7'; '^^^<<'
    when '8'; '<^^^'
    when '9'; '^^^'
    end
  when '0'
    case to
    when 'A'; '>'
    when '0'; ''
    when '1'; '^<'
    when '2'; '^'
    when '3'; '^>'
    when '4'; '^^<'
    when '5'; '^^'
    when '6'; '^^>'
    when '7'; '^^^<'
    when '8'; '^^^'
    when '9'; '^^^>'
    end
  when '1'
    case to
    when 'A'; '>>v'
    when '0'; '>v'
    when '1'; ''
    when '2'; '>'
    when '3'; '>>'
    when '4'; '^'
    when '5'; '^>'
    when '6'; '^>>'
    when '7'; '^^'
    when '8'; '^^>'
    when '9'; '^^>>'
    end
  when '2'
    case to
    when 'A'; 'v>'
    when '0'; 'v'
    when '2'; ''
    when '1'; 'v'
    when '3'; '>'
    when '4'; '<^'
    when '5'; '^'
    when '6'; '^>'
    when '7'; '<^^'
    when '8'; '^^'
    when '9'; '^^>'
    end
  when '3'
    case to
    when 'A'; 'v'
    when '0'; '<v'
    when '1'; '<<'
    when '2'; '<'
    when '3'; ''
    when '4'; '<<^'
    when '5'; '<^'
    when '6'; '^'
    when '7'; '<<^^'
    when '8'; '<^^'
    when '9'; '^^'
    end
  when '4'
    case to
    when 'A'; '>>vv'
    when '0'; '>vv'
    when '1'; 'v'
    when '2'; 'v>'
    when '3'; 'v>>'
    when '4'; ''
    when '5'; '>'
    when '6'; '>>'
    when '7'; '^'
    when '8'; '^>'
    when '9'; '^>>'
    end
  when '5'
    case to
    when 'A'; 'vv>'
    when '0'; 'vv'
    when '1'; '<v'
    when '2'; 'v'
    when '3'; 'v>'
    when '4'; '<'
    when '5'; ''
    when '6'; '>'
    when '7'; '<^'
    when '8'; '^'
    when '9'; '^>'
    end
  when '6'
    case to
    when 'A'; 'vv'
    when '0'; '<vv'
    when '1'; '<<v'
    when '2'; '<v'
    when '3'; 'v'
    when '4'; '<<'
    when '5'; '<'
    when '6'; ''
    when '7'; '<<^'
    when '8'; '<^'
    when '9'; '^'
    end
  when '7'
    case to
    when 'A'; '>>vvv'
    when '0'; '>vvv'
    when '1'; 'vv'
    when '2'; 'vv>'
    when '3'; 'vv>>'
    when '4'; 'v'
    when '5'; 'v>'
    when '6'; 'v>>'
    when '7'; ''
    when '8'; '>'
    when '9'; '>>'
    end
  when '8'
    case to
    when 'A'; 'vvv>'
    when '0'; 'vvv'
    when '1'; '<vv'
    when '2'; 'vv'
    when '3'; 'vv>'
    when '4'; '<v'
    when '5'; 'v'
    when '6'; 'v>'
    when '7'; '<'
    when '8'; ''
    when '9'; '>'
    end
  when '9'
    case to
    when 'A'; 'vvv'
    when '0'; '<vvv'
    when '1'; '<<vv'
    when '2'; '<vv'
    when '3'; 'vv'
    when '4'; '<<v'
    when '5'; '<v'
    when '6'; 'v'
    when '7'; '<<'
    when '8'; '<'
    when '9'; ''
    end
  end
end

def arrow_keypad_best_path(from, to)
  case from
  when 'A'
    case to
    when 'A'; ''
    when '^'; '<'
    when '<'; 'v<<'
    when 'v'; 'v<'
    when '>'; 'v'
    end
  when '^'
    case to
    when 'A'; '>'
    when '^'; ''
    when '<'; 'v<'
    when 'v'; 'v'
    when '>'; 'v>'
    end
  when '<'
    case to
    when 'A'; '>>^'
    when '^'; '>^'
    when '<'; ''
    when 'v'; '>'
    when '>'; '>>'
    end
  when 'v'
    case to
    when 'A'; '^>'
    when '^'; '^'
    when '<'; '<'
    when 'v'; ''
    when '>'; '>'
    end
  when '>'
    case to
    when 'A'; '^'
    when '^'; '<^'
    when '<'; '<<'
    when 'v'; '<'
    when '>'; ''
    end
  end
end

def now
  Time.now.strftime("%H:%M:%S")
end

MAX_PRECOMPUTE_LENGTH = 12

def complexity(code, presses_needed)
  pp "For code #{code}, presses needed: #{presses_needed} (len #{presses_needed.length}), complexity: #{code.to_i * presses_needed.length}"

  code.to_i * presses_needed.length
end

codes = File.readlines('day-21/input.txt').map(&:chomp)

total_complexity = 0

@memo = {}
memo_lengths = Set.new
sorted_memo_lengths = []

codes.each do |code|
  p code

  keypad_robot_position = 'A'
  robot_1_presses_needed = ''
  code.each_char do |char|
    robot_1_presses_needed << numeric_keypad_best_path(keypad_robot_position, char)
    robot_1_presses_needed << 'A'
    keypad_robot_position = char
  end

  prev_robot_presses_needed = robot_1_presses_needed
  25.times do |i|
    p "#{now} Robot ##{i}"

    j = 0

    robot_position = 'A'
    next_robot_presses_needed = ''

    loop do
      precompute_used = false
      if robot_position == 'A'
        sorted_memo_lengths.each do |precompute_length|
          if @memo.key?(prev_robot_presses_needed[j...j+precompute_length])
            next_robot_presses_needed << @memo[prev_robot_presses_needed[j...j+precompute_length]]
            robot_position = next_robot_presses_needed[-1]
            j += precompute_length
            precompute_used = true
            break
          end
        end
      end
      if !precompute_used
        char = prev_robot_presses_needed[j]
        next_robot_presses_needed << arrow_keypad_best_path(robot_position, char)
        next_robot_presses_needed << 'A'
        robot_position = char
        j += 1
      end

      if robot_position == 'A'
        @memo[prev_robot_presses_needed[0...j]] = next_robot_presses_needed.dup
        if !memo_lengths.include?(prev_robot_presses_needed[0...j].length)
          memo_lengths.add(prev_robot_presses_needed[0...j].length)
          sorted_memo_lengths = memo_lengths.to_a.sort.reverse
        end
      end

      break if j >= prev_robot_presses_needed.length
    end
    prev_robot_presses_needed = next_robot_presses_needed
  end

  total_complexity += complexity(code, prev_robot_presses_needed)
end

p total_complexity
