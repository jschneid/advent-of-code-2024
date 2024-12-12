class Region
  attr_accessor :area, :plant, :corner_count

  def initialize(plant)
    @area = 0
    @plant = plant
    @corner_count = 0
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

def plant_at(map, plot)
  return '.' unless in_bounds?(map, plot)

  map[plot.y][plot.x]
end

def corner_count(map, plot)
  # Build a set of the 3 neighboring plots for each of the four corners of the current plot.
  # For example, one such set of 3 neighboring corners "N" of the current plot "X" would be:
  # NN.
  # NX.
  # ...
  corner_neighbor_plot_sets = [
    [Plot.new(plot.y - 1, plot.x - 1), Plot.new(plot.y - 1, plot.x), Plot.new(plot.y, plot.x - 1)],
    [Plot.new(plot.y - 1, plot.x + 1), Plot.new(plot.y - 1, plot.x), Plot.new(plot.y, plot.x + 1)],
    [Plot.new(plot.y + 1, plot.x - 1), Plot.new(plot.y + 1, plot.x), Plot.new(plot.y, plot.x - 1)],
    [Plot.new(plot.y + 1, plot.x + 1), Plot.new(plot.y + 1, plot.x), Plot.new(plot.y, plot.x + 1)]
  ]

  # For each pair of a plot and its three neighboring corners, there is a corner if the pattern of
  # plants is either of the following two (where "A" is the current plant, and "B" is a different plant):
  #                 ?B.                     BA.
  # (Convex corner) BA.    (Concave corner) AA.
  #                 ...                     ...
  plant = map[plot.y][plot.x]
  corners = 0
  corner_neighbor_plot_sets.each do |neighbor_plots|
    if plant_at(map, neighbor_plots[1]) != plant && plant_at(map, neighbor_plots[2]) != plant
      # There's a convex corner here.
      corners += 1
    elsif plant_at(map, neighbor_plots[0]) != plant && plant_at(map, neighbor_plots[1]) == plant && plant_at(map, neighbor_plots[2]) == plant
      # There's a concave corner here.
      corners += 1
    end
  end
  corners
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

  # It's easier to calculate the count of corners of each region than the count of edges,
  # because we can calculate the corners of a plot by looking just at its immediate neighbors.
  # And, for any region shape, the count of corners is EQUAL TO the count of edges.
  # So we'll count the corners instead of computing the edges.
  region.corner_count += corner_count(map, plot)

  neighboring_plots.each do |neighboring_plot|
    if in_bounds?(map, neighboring_plot) && plant_at(map, neighboring_plot) == region.plant
      explore(region, neighboring_plot, plots_to_regions, map)
    end
  end
end

map = File.readlines("day-12/input.txt").map(&:chomp)

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
  total_cost += region.area * region.corner_count
end
p total_cost
