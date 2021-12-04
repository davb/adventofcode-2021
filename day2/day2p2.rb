#!/usr/bin/env ruby

p = [0,0]
a = 0
File.foreach("input.txt") do |l|
  l.match(/(up|down|forward) (\d+)/) do |m|
    x = m[2].to_i
    if m[1] == "forward"
      p[0] += x
      p[1] += a*x
    end
    a -= x if m[1] == "up"
    a += x if m[1] == "down"
  end
end
puts "part2:", p[0]*p[1]
