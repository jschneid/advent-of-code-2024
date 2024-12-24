# I struggled with attempts at Day 21 Part 2 implementations involving precomputation and/or memoization of
# intermediate results.
#
# The "light bulb" moment happened for me when I realized that this could be implemented like Day 11 Part 2!
# The order of each relative pair of moves doesn't matter. We just need to keep track of, for each generation,
# how many times we're moving from each position to each other position. Each of those "moves" can be used to
# directly compute the set of moves for the next generation -- same as for each individual "replicating stone"
# from Day 11.
#
# This solution returns immediately. Much better than the projected 24+ hour runtimes of my other attempts!

def numeric_keypad_best_path(from, to)
  # The orderings of the moves here matter -- some result in cheaper solutions than others. I came up with the
  # correct orderings by (1) realizing that the orderings matter by comparing my original (too expensive)
  # solution from Part 1 to the problem statement's solution, and seeing that the problem's statement's solution
  # had a shorter set of moves; (2) coming up with a couple of simple heuristics for correct orderings, e.g.
  # don't change direction more than necessary (e.g. no '>^>' instead of '>>^'), and always move left as much
  # as possible first; (3) guess-and-check by tweaking a few individual orderings and seeing if they produced
  # a lower result.
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
  # Some orderings don't matter until the 5th generation for my input -- my Part 1 orderings produced a
  # correct result for 2 generations / Part 1, but needed to be tweaked for 25 generations / Part 2.
  case from
  when 'A'
    case to
    when 'A'; ''
    when '^'; '<'
    when '<'; 'v<<'
    when 'v'; '<v'
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

# Create a hashmap of each move (pair of "from" / origin, and "to" / destination), to the set of moves
# needed by the controlling robot to produce that movement in the robot being controlled.
def generate_key_pairs
  key_pairs = {}
  ['<', 'v', '>', '^', 'A'].repeated_permutation(2).each do |from, to|
    # Each moves starts at position 'A'; and needs another 'A' at the end to "submit" the move.
    key_pairs[[from, to]] = ('A' << arrow_keypad_best_path(from, to) << 'A').chars.each_cons(2).to_a
  end
  key_pairs
end

def complexity(code, presses_needed)
  code.to_i * (presses_needed.values.sum - 1)
end

codes = File.readlines('day-21/input.txt').map(&:chomp)
key_pairs = generate_key_pairs
total_complexity = 0

codes.each do |code|
  keypad_robot_position = 'A'
  robot_1_presses_needed = ''
  code.each_char do |char|
    robot_1_presses_needed << numeric_keypad_best_path(keypad_robot_position, char)
    robot_1_presses_needed << 'A'
    keypad_robot_position = char
  end

  prev_robot_presses_needed = Hash.new(0)
  ('A' << robot_1_presses_needed << 'A').chars.each_cons(2) do |from, to|
    prev_robot_presses_needed[[from, to]] += 1
  end

  25.times do
    next_robot_presses_needed = Hash.new(0)

    prev_robot_presses_needed.each do |pair, count|
      key_pairs[pair].each do |to|
        next_robot_presses_needed[to] += count
      end
    end

    prev_robot_presses_needed = next_robot_presses_needed
  end

  total_complexity += complexity(code, prev_robot_presses_needed)
end

p total_complexity
