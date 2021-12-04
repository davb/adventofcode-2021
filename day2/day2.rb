#!/usr/bin/env ruby

p = [0, 0]
File.foreach("input.txt") do |l|
  l.match(/(up|down|forward) (\d+)/) do |m|
    d = m[2].to_i
    p[0] += d if m[1] == "forward"
    p[1] -= d if m[1] == "up"
    p[1] += d if m[1] == "down"
  end
end
puts "part1:", p[0]*p[1]
