def key?(object)
  object[0] == '.....'
end

def key_pin_height(key, column)
  key.map { |line| line[column] }.join.reverse.index('.') - 1
end

def key_pin_heights(key)
  pin_heights = []
  5.times do |column|
    pin_heights << key_pin_height(key, column)
  end
  pin_heights
end

def lock_pin_height(lock, column)
  lock.map { |line| line[column] }.join.index('.') - 1
end

def lock_pin_heights(lock)
  pin_heights = []
  5.times do |column|
    pin_heights << lock_pin_height(lock, column)
  end
  pin_heights
end

def fits?(key_map, lock_map)
  5.times do |column|
    return false if key_map[column] + lock_map[column] > 5
  end
  true
end

def fit_count(key_maps, lock_maps)
  fit_count = 0
  key_maps.each do |key_map|
    lock_maps.each do |lock_map|
      fit_count += 1 if fits?(key_map, lock_map)
    end
  end
  fit_count
end

def parse_input(lines)
  keys = []
  locks = []
  objects = lines.each_slice(8)

  objects.map { |object| object[..6] }.each do |object|
    if key?(object)
      keys << object
    else
      locks << object
    end
  end

  [keys, locks]
end

lines = File.readlines('day-25/input.txt').map(&:chomp)
keys, locks = parse_input(lines)

key_maps = keys.map { |key| key_pin_heights(key) }
lock_maps = locks.map { |lock| lock_pin_heights(lock) }

p fit_count(key_maps, lock_maps)
