filename = 'input_1.txt'
total = 0
File.readlines(filename).each do |line|
  total += line.to_i/3 - 2
end

puts total
