# !/usr/bin/env ruby

# Solved using a binary tree with weighted nodes
class Node

  def initialize
    @children = [nil, nil]
    @counts = [0, 0]
  end

  # insert a binary number (as Array) into the tree
  # it is added to the left child if it starts with 0, otherwise to the right
  def insert b
    @children[0] ||= Node.new
    @children[1] ||= Node.new
    return if b.empty?
    h = b[0].to_i
    @children[h].insert b[1..-1]
    @counts[h] += 1 
  end

  # traverse the tree to compute Oxygen and CO2
  # Oxygen takes the path with highest weight, CO2 the one with lowest
  def traverse
    return [[],[]] if @counts[0] + @counts[1] == 0
    most = (@counts[0] == 0 || @counts[1] >= @counts[0]) ? 1 : 0
    least = (@counts[0] == 0 || @counts[1] < @counts[0]) ? 1 : 0
    return [
      [most].concat(@children[most].traverse[0]),
      [least].concat(@children[least].traverse[1])
    ]
  end

end

# binary (as Array) to decimal conversion
def to_dec bin
  return bin.empty? ? 0 : (bin[0] * 2**(bin.length-1) + to_dec(bin[1..-1]))
end

# insert each number from the input into a tree
n = Node.new
File.foreach("input.txt"){|l| n.insert(l.scan(/\d/).to_a)}

# traverse the tree
t = n.traverse
o2 = to_dec(t[0])
co2 = to_dec(t[1])

puts "part2:", o2*co2
