filename = 'input_1.txt'
fuels = []

modules = File.readlines(filename).map do |line|
  line.to_i
end

modules.each do |mass|
  fuels << (mass/3) - 2
  while(fuels.last != 0)
    next_fuel = (fuels.last/3) - 2
    if next_fuel.negative?
      fuels << 0
    else
      fuels << next_fuel
    end
  end
end

puts fuels.sum
