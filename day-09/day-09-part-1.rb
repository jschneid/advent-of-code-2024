def disk_blocks(disk_map)
  file_id = 0
  blocks = []

  disk_map.each_char.with_index do |char, index|
    if index % 2 == 0
      char.to_i.times do
        blocks << file_id
      end
      file_id += 1
    else
      char.to_i.times do
        blocks << nil
      end
    end
  end

  blocks
end

def fragment_disk(disk)
  while disk.include?(nil)
    if disk[-1] != nil
      leftmost_empty_block = disk.index(nil)
      disk[leftmost_empty_block] = disk[-1]
    end
    disk.pop
  end

  disk
end

def filesystem_checksum(disk)
  checksum = 0
  disk.each_with_index do |file_id, index|
    checksum += index * file_id
  end
  checksum
end

disk_map = File.read("day-09/input.txt").chomp
disk = disk_blocks(disk_map)
disk = fragment_disk(disk)

p filesystem_checksum(disk)
