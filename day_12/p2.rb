require 'pry'

class Moon
  attr_reader :x
  attr_reader :x_velocity

  def initialize(x)
    @x = x
    @x_velocity = 0
  end

  def update_position
    @x = @x + @x_velocity
  end

  def update_velocity_with(moon)
    if @x > moon.x
      @x_velocity -= 1
    elsif @x < moon.x
      @x_velocity += 1
    end
  end

  def print
    puts "pos=<x=#{@x}>, vel=<x=#{@x_velocity}>"
  end
end

def update_velocity_of_pair(pair)
  pair.first.update_velocity_with(pair.last)
  pair.last.update_velocity_with(pair.first)
end

x_moons = []
y_moons = []
z_moons = []

File.read('input1.txt').chomp.split("\n").each do |initial|
  x, y, z = initial.match(/<x=(.+), y=(.+), z=(.+)>/i).captures
  x_moons << Moon.new(x.to_i)
  y_moons << Moon.new(y.to_i)
  z_moons << Moon.new(z.to_i)
end

# break when position is the same as initial
# this algorithm works if you can prove that for every state, there will be a point where you loop back to it.
# If that is proved -> then the intial state is the first state that will be looped first
results = []
step = 0
while true do
  step += 1
  x_moons.combination(2) do |pair|
    update_velocity_of_pair(pair)
  end

  x_moons.each(&:update_position)
  if x_moons.all? { |moon| moon.x_velocity == 0 }
    results << step
    break
  end
end

step = 0
while true do
  step += 1
  y_moons.combination(2) do |pair|
    update_velocity_of_pair(pair)
  end

  y_moons.each(&:update_position)
  if y_moons.all? { |moon| moon.x_velocity == 0 }
    results << step
    break
  end
end

step = 0
while true do
  step += 1
  z_moons.combination(2) do |pair|
    update_velocity_of_pair(pair)
  end

  z_moons.each(&:update_position)
  if z_moons.all? { |moon| moon.x_velocity == 0 }
    results << step
    break
  end
end

puts results
puts results.reduce(1, :lcm) * 2
