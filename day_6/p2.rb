require 'pry'

class Node
  attr_reader :value
  attr_accessor :parent
  attr_accessor :children

  def initialize(value, parent=nil, children=[])
    @value=value
    @parent=parent
    @children=children
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
      node.children << new_node
    end
  end
end

tree.each do |node|
  insert(node,tree)
end

santa=nil
you=nil

tree.each do |node|
  santa=node if node.value == "SAN"
  you=node if node.value == "YOU"
end

def calculate_shortest_path(from_node, to_node,tracked={})
  return 0 if from_node.value == to_node.value
  return 1492 if from_node.parent.nil?
  return 1492 if from_node.children.empty?

  tracked[from_node.value] = true

  parent_path = if from_node.parent && !tracked[from_node.parent.value]
    calculate_shortest_path(from_node.parent,to_node,tracked) + 1
  end

  child_paths = from_node.children.map do |child|
    unless tracked[child.value]
      calculate_shortest_path(child,to_node,tracked) + 1
    end
  end

  (child_paths + [parent_path]).compact.min
end

puts calculate_shortest_path(you.parent, santa.parent)
