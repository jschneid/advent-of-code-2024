class Cluster
  attr_accessor :file_id, :index, :blocks

  def initialize(file_id, index, blocks)
    @file_id = file_id
    @index = index
    @blocks = blocks
  end
end

def file_allocation(disk_map)
  file_id = 0
  disk_index = 0
  file_blocks = []
  free_blocks = []

  disk_map.each_char.with_index do |char, disk_map_index|
    blocks = char.to_i
    if disk_map_index % 2 == 0
      file_blocks << Cluster.new(file_id, disk_index, blocks)
      file_id += 1
    else
      free_blocks << Cluster.new(nil, disk_index, blocks)
    end
    disk_index += blocks
  end

  [file_blocks, free_blocks]
end

def compact_disk(file_blocks, free_blocks)
  file_blocks.reverse_each do |file_block|
    free_blocks.each do |free_block|
      break if free_block.index > file_block.index

      if free_block.blocks >= file_block.blocks
        file_block.index = free_block.index
        free_block.blocks -= file_block.blocks
        free_block.index += file_block.blocks
        break
      end
    end
  end
end

def filesystem_checksum(file_blocks)
  checksum = 0
  file_blocks.each do |file_block|
    (file_block.index...file_block.index + file_block.blocks).each do |index|
      checksum += index * file_block.file_id
    end
  end
  checksum
end

disk_map = File.read("day-09/input.txt").chomp
file_blocks, free_blocks = file_allocation(disk_map)
compact_disk(file_blocks, free_blocks)

p filesystem_checksum(file_blocks)
