#!/usr/bin/env ruby

n = 0
j = nil
File.foreach("input.txt") do |l|
  i = l.to_i
  n += 1 if j && i > j
  j = i
end
puts n
