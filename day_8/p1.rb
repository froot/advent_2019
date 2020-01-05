require 'pry'
image = File.read('input1.txt').chomp.split('').map(&:to_i)
layer_size = 25*6
num_of_layers = image.count / layer_size - 1

hash = Hash[(0..num_of_layers).to_a.map { |x| [x, { 0=>0, 1=>0, 2=>0, number: 0}]}]
zero_hash = {}

image.each_with_index do |digit, i|
  key = i/layer_size
  hash[key][digit] = hash[key][digit] + 1
  hash[key][:number] = hash[key][:number] + 1
end

hash.each do |k, v|
  if zero_hash[v[0]]
    zero_hash[v[0]] << k
  else
    zero_hash[v[0]] = [k]
  end
end

layer = zero_hash[zero_hash.keys.min].first
puts hash[layer][1] * hash[layer][2]
