lines = File.foreach("input.txt").map{|l| l.scan(/\d/).to_a.map(&:to_i)}

score = 0
lines.each_index do |i|
  lines[i].each_index do |j|
    low = ![[-1,0],[1,0],[0,-1],[0,1]].any? do |(di,dj)|
      k, l = i+di, j+dj
      k >= 0 && l >= 0 && k < lines.length && l < lines[k].length && lines[k][l] <= lines[i][j]
    end
    score += 1 + lines[i][j] if low
  end
end

puts "part1:", score
