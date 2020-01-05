require 'pry'

class Node
  attr_reader :value
  attr_accessor :parent

  def initialize(value, parent=nil)
    @value=value
    @parent=parent
  end
end

input = File.read('input1.txt').chomp

orbits = input.split("\n").map { |n| n.split(")") }

# build tree
tree=[Node.new("COM")]

orbits.each do |orbit|
  # inserts parent as stand-in string
  tree << Node.new(orbit.last, orbit.first)
end

def insert(new_node,tree)
  tree.each do |node|
    if node.value == new_node.parent
      new_node.parent = node
    end
  end
end

tree.each do |node|
  insert(node,tree)
end

binding.pry

def calculate_height(node)
  if node.parent.nil?
    0
  else
    calculate_height(node.parent) + 1
  end
end

heights = tree.map do |node|
  calculate_height(node)
end

puts heights.sum
