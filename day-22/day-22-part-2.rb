# This isn't a very optimal solution; it takes about 90 minutes to run on my Mac.

def mix(x64, secret_number)
  x64 ^ secret_number
end

def prune(secret_number)
  secret_number % 16777216
end

def evolve(secret_number)
  x64 = secret_number * 64
  secret_number = mix(x64, secret_number)
  secret_number = prune(secret_number)

  d32 = secret_number / 32
  secret_number = mix(d32, secret_number)
  secret_number = prune(secret_number)

  m2048 = secret_number * 2048
  secret_number = mix(m2048, secret_number)
  prune(secret_number)
end

secret_numbers = File.readlines('day-22/input.txt').map(&:to_i)
secret_number_sequences = secret_numbers.map { |secret_number| [secret_number] }

2000.times do
  secret_number_sequences.each do |secret_number_sequence|
    secret_number = secret_number_sequence.last
    secret_number_sequence << evolve(secret_number)
  end
end

price_sequences = []
secret_number_sequences.each do |secret_number_sequence|
  price_sequences << secret_number_sequence.map { |secret_number| secret_number % 10 }
end

delta_sequences = []
price_sequences.each do |price_sequence|
  delta_sequence = []
  (1...price_sequence.length).each do |i|
    delta_sequence << price_sequence[i] - price_sequence[i - 1]
  end
  delta_sequences << delta_sequence
end

# Reduce the search space of possible delta 4-sequences by including only those that result in a maximum ("9") sale.
# It's not GUARANTEED that any possible input's solution would include such a sequence, but it's HIGHLY likely!)
deltas_before_a_9 = []
price_sequences.each_with_index do |price_sequence, price_sequence_index|
  price_sequence.each_with_index do |price, i|
    if price == 9 && i >= 4
      deltas_before_a_9 << delta_sequences[price_sequence_index][i-4..i-1]
    end
  end
end
deltas_before_a_9 = deltas_before_a_9.uniq

max_bananas = 0
deltas_before_a_9.each do |target_sequence|
  sequence_bananas = 0
  delta_sequences.each_with_index do |delta_sequence, sequence_index|
    (3...delta_sequence.length).each do |i|
      if delta_sequence[i] == target_sequence[3] && delta_sequence[i - 1] == target_sequence[2] && delta_sequence[i - 2] == target_sequence[1] && delta_sequence[i - 3] == target_sequence[0]
        sequence_bananas += price_sequences[sequence_index][i+1]
        break
      end
    end
  end
  max_bananas = sequence_bananas if sequence_bananas > max_bananas
end

p max_bananas
