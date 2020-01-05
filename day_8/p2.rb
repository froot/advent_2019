require 'pry'
image = File.read('input1.txt').chomp.split('').map(&:to_i)
layer_size = 25*6

hash = {}

image.each_with_index do |digit, i|
  key = i.modulo(layer_size)
  if hash[key]
    hash[key] << digit
  else
    hash[key] = [digit]
  end
end

hash.each do |index, array|
  while(array.first == 2)
    array.shift
  end
  if array.first == 0
    print " "
  else
    print 0
  end

  if index.modulo(25) == (25 - 1)
    print "\n"
  end
end
