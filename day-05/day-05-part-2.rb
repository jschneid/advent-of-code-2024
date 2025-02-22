class Rule
  attr_accessor :first, :second

  def initialize(rule_line)
    split_rule = rule_line.split('|').map(&:to_i)
    @first = split_rule[0]
    @second = split_rule[1]
  end
end

def in_right_order?(page_numbers, rules)
  page_numbers.each_with_index do |page_number, page_index|
    page_numbers.each_with_index do |other_page_number, other_page_index|
      next if page_index == other_page_index

      rules.each do |rule|
        if other_page_index < page_index
          return false if rule.first == page_number && rule.second == other_page_number
        else
          return false if rule.first == other_page_number && rule.second == page_number
        end
      end
    end
  end

  true
end

# Looks through the page numbers and rules to find a pair of pages that are out of order.
# If it finds such a pair, swaps them, and returns false. Otherwise, returns true.
# (So calling this repeatedly until it returns true will fix the page order.)
def fix_order(page_numbers, rules)
  page_numbers.each_with_index do |page_number, page_index|
    page_numbers.each_with_index do |other_page_number, other_page_index|
      next if page_index == other_page_index

      rules.each do |rule|
        if other_page_index < page_index
          if rule.first == page_number && rule.second == other_page_number
            page_numbers[page_index], page_numbers[other_page_index] = page_numbers[other_page_index], page_numbers[page_index]
            return false
          end
        else
          if rule.first == other_page_number && rule.second == page_number
            page_numbers[page_index], page_numbers[other_page_index] = page_numbers[other_page_index], page_numbers[page_index]
            return false
          end
        end
      end
    end
  end

  true
end

input_lines = File.readlines("day-05/input.txt").map(&:chomp)
partitioned_input = input_lines.partition { |line| line.include?('|') }.to_a
rule_lines = partitioned_input[0]
page_number_lines = partitioned_input[1][1..]

rules = rule_lines.map { |rule_line| Rule.new(rule_line) }

total_middle_page_numbers_of_corrected_page_lines = 0
page_number_lines.each do |page_number_line|
  page_numbers = page_number_line.split(',').map(&:to_i)
  unless in_right_order?(page_numbers, rules)
    until fix_order(page_numbers, rules) do end

    total_middle_page_numbers_of_corrected_page_lines += page_numbers[(page_numbers.length - 1) / 2]
  end
end

p total_middle_page_numbers_of_corrected_page_lines
