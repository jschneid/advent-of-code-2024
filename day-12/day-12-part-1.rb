class Region
  attr_accessor :perimeter, :area, :plant

  def initialize(plant)
    @perimeter = 0
    @area = 0
    @plant = plant
  end
end

class Plot
  attr_accessor :y, :x

  def initialize(y, x)
    @y = y
    @x = x
  end

  def eql?(other)
    other.is_a?(Plot) && @y == other.y && @x == other.x
  end

  def hash
    @y.hash ^ @x.hash
  end
end

def in_bounds?(map, plot)
  return false if plot.y < 0 || plot.y >= map.length
  return false if plot.x < 0 || plot.x >= map[0].length
  true
end

def explore(region, plot, plots_to_regions, map)
  return if plots_to_regions.key?(plot)

  plots_to_regions[plot] = region
  region.area += 1

  neighboring_plots = [
    Plot.new(plot.y, plot.x - 1),
    Plot.new(plot.y, plot.x + 1),
    Plot.new(plot.y + 1, plot.x),
    Plot.new(plot.y - 1, plot.x)
  ]

  neighboring_plots.each do |neighboring_plot|
    if in_bounds?(map, neighboring_plot) && map[neighboring_plot.y][neighboring_plot.x] == region.plant
      explore(region, neighboring_plot, plots_to_regions, map)
    else
      region.perimeter += 1
    end
  end
end

map = File.readlines("day-12/input.txt").map(&:chomp)

# Although it initially seemed more "intuitive" to set up a map of regions to their plots,
# it's actually more efficient to do the inverse and use plots as the hash keys, giving us O(1)
# lookup of whether a given plot has already been "explored" and assigned to a region (which
# is a check that we perform a lot in this solution).
plots_to_regions = {}

map.each_index do |y|
  (0...map[0].length).each do |x|
    plot = Plot.new(y, x)
    next if plots_to_regions.key?(plot)

    region = Region.new(map[y][x])
    explore(region, plot, plots_to_regions, map)
  end
end

total_cost = 0
plots_to_regions.values.uniq.each do |region|
  total_cost += region.area * region.perimeter
end
p total_cost
