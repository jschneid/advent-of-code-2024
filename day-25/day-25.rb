def key?(object)
  object[0] == '.....'
end

def key_pin_height(key, column)
  key.map { |line| line[column] }.join.reverse.index('.') - 1
end

def key_pin_heights(key)
  (0..4).map { |column| key_pin_height(key, column) }
end

def lock_pin_height(lock, column)
  lock.map { |line| line[column] }.join.index('.') - 1
end

def lock_pin_heights(lock)
  (0..4).map { |column| lock_pin_height(lock, column) }
end

def fits?(key_map, lock_map)
  (0..4).all? { |column| key_map[column] + lock_map[column] <= 5 }
end

def fit_count(key_maps, lock_maps)
  key_maps.product(lock_maps).count { |key_map, lock_map| fits?(key_map, lock_map) }
end

def parse_input(lines)
  lines.each_slice(8).map { |object| object[..6] }.partition { |object| key?(object) }
end

lines = File.readlines('day-25/input.txt').map(&:chomp)
keys, locks = parse_input(lines)

key_maps = keys.map { |key| key_pin_heights(key) }
lock_maps = locks.map { |lock| lock_pin_heights(lock) }

p fit_count(key_maps, lock_maps)
