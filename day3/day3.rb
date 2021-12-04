# !/usr/bin/env ruby

c = []
n = 0
File.foreach("input.txt") do |l|
  l.scan(/\d/).each_with_index do |k, i|
    c[i] = 0 if c[i].nil?
    c[i] += 1 if k == '0' # count zeroes in position i
  end
  n += 1
end
g = 0
e = 0
c.each_index do |i|
  b = c[i] > n/2 ? 0 : 1 # most common bit in position i, least common is (1-b)
  g += b * 2**(c.length - 1 - i) # gamma, in decimal
  e += (1-b) * 2**(c.length - 1 - i) # epsilon, in decimal
end
puts "part1:", g*e
