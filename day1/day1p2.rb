#!/usr/bin/env ruby

n = 0
a = nil
b = nil
c = nil
d = nil
File.foreach("input.txt") do |l|
  a = b
  b = c
  c = d
  d = l.to_i
  n += 1 if a && d + c + b > c + b + a
end
puts n
