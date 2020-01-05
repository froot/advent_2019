require 'pry'

map = File.read('input1.txt').chomp.split("\n")

aster_coords = []
map.each_with_index do |row, i|
  row.chars.each_with_index do |column, j|
    aster_coords << [j, i] if column == "#"
  end
end

results = {}

a1 = [22, 19]
#a1 = [11,13]

angles_and_distances = aster_coords.map do |a2|
  next if a1 == a2
  opposite = a2.last - a1.last
  adjacent = a2.first - a1.first

  angle = Math.atan2(opposite,adjacent)
  length = if angle == 0 || angle.abs == Math::PI/2 ||
               angle.abs == 2*Math::PI
             if adjacent == 0
               opposite
             else
               adjacent
             end
           else
             adjacent*Math.cos(angle)
           end

  [angle, length, a2.first, a2.last]
end

hash = {}
angles_and_distances.compact.each do |x|
  angle = x.shift
  if hash[angle]
    hash[angle] << x
  else
    hash[angle] = [x]
  end
end

hash.transform_values! do |asteroids|
  asteroids.sort_by { |info| info.first }
end

hash = hash.sort_by do |key, value|
  if key < -Math::PI/2 && key > -Math::PI
    key + (4*Math::PI)
  else
    key
  end
end

counter = 0
while (counter < 201) do
  hash.map do |info|
    counter+=1
    asteroids = info.last
    angle = info.first

    hit = asteroids.shift 
    if counter == 200
      puts hit.fetch(1) * 100 + hit.fetch(2)
    end

    [angle, asteroids]
  end
end
