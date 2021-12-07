covered = Hash.new(0)
File.foreach("input.txt") do |l|
  x1, y1, x2, y2 = *l.scan(/\d+/).to_a.map(&:to_i)
  dx = (x2 - x1) <=> 0 # -1 or 0 or 1
  dy = (y2 - y1) <=> 0 # -1 or 0 or 1
  if dx == 0 || dy == 0 # part 1: horizontal or vertical only
    x, y = x1, y1
    loop do
      covered[[x, y]] += 1
      break if [x, y] == [x2, y2]
      x, y = x + dx, y + dy
    end
  end
end

# count points covered by 2 lines or more
puts "part1:", covered.reduce(0){|c, (k, v)| v > 1 ? c + 1 : c}

