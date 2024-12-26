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

2000.times do
  secret_numbers.each_with_index do |secret_number, i|
    secret_numbers[i] = evolve(secret_number)
  end
end

p secret_numbers.sum


