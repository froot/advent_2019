require 'pry'

map = File.read('input1.txt').chomp.split("\n")

aster_coords = []
map.each_with_index do |row, i|
  row.chars.each_with_index do |column, j|
    aster_coords << [j, i] if column == "#"
  end
end

results = []

aster_coords.each do |a1|
  # calculate angles and distances
  angles_and_distances = aster_coords.map do |a2|
    next if a1 == a2
    opposite = a2.last - a1.last
    adjacent = a2.first - a1.first

    angle = Math.atan2(opposite,adjacent)
    length = adjacent*Math.cos(angle)
    [angle, length]
  end

  hash = {}
  angles_and_distances.compact.each do |x|
    if hash[x.first]
      hash[x.first] << x.last
    else
      hash[x.first] = [x.last]
    end
  end

  results << hash.count
end

puts results.max
