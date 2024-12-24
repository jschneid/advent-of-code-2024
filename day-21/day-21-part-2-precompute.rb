# Failed implementation attempt which tried to speed up runtime via precomputation of sets of consecutive positions
# with the next generation set of positions. (This was slightly affected for smaller generation counts, but the huge
# length of the string at generations ~16+ still resulted in a projected runtime of 24+ hours.)


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

MAX_PRECOMPUTE_LENGTH = 10

@precomputed_precomputed_arrow_keypad_best_paths = {}

def precompute_arrow_keypad_best_paths
  2.upto(MAX_PRECOMPUTE_LENGTH) do |precompute_length|
    pp "#{now} Precomputing some best paths (length: #{precompute_length})..."
    ['<', 'v', '>', '^', 'A'].repeated_permutation(precompute_length - 1).each do |permutation|
      next_path = ''
      prev_position = 'A'
      permutation << 'A'
      permutation.join.each_char do |char|
        next_path << arrow_keypad_best_path(prev_position, char) << 'A'
        prev_position = char
      end
      @precomputed_precomputed_arrow_keypad_best_paths[permutation.join] = next_path
    end
  end
end

def complexity(code, presses_needed)
  pp "For code #{code}, presses needed length: #{presses_needed.length}, complexity: #{code.to_i * presses_needed.length}"

  code.to_i * presses_needed.length
end

codes = File.readlines('day-21/input.txt').map(&:chomp)

total_complexity = 0

precompute_arrow_keypad_best_paths

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

    robot_position = 'A'
    next_robot_presses_needed = ''

    j = 0
    loop do
      precompute_used = false
      if robot_position == 'A'
        MAX_PRECOMPUTE_LENGTH.downto(2) do |precompute_length|
          if @precomputed_precomputed_arrow_keypad_best_paths.key?(prev_robot_presses_needed[j...j+precompute_length])
            # pp "At #{j} next substring is #{prev_robot_presses_needed[j...j+PRECOMPUTE_LENGTH]} so appending #{@precomputed_precomputed_arrow_keypad_best_paths[prev_robot_presses_needed[j...j+PRECOMPUTE_LENGTH]]}"
            next_robot_presses_needed << @precomputed_precomputed_arrow_keypad_best_paths[prev_robot_presses_needed[j...j+precompute_length]]
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
      break if j >= prev_robot_presses_needed.length
    end
    prev_robot_presses_needed = next_robot_presses_needed
  end

  total_complexity += complexity(code, prev_robot_presses_needed)
end

p total_complexity
