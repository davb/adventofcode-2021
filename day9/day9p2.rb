lines = File.foreach("input.txt").map{|l| l.scan(/\d/).to_a.map(&:to_i)}

basins = []
lines.each_index do |i|
  lines[i].each_index do |j|
    low = ![[-1,0],[1,0],[0,-1],[0,1]].any? do |(di,dj)|
      k, l = i+di, j+dj
      k >= 0 && l >= 0 && k < lines.length && l < lines[k].length && lines[k][l] <= lines[i][j]
    end
    basins << [[i, j]] if low
  end
end

sizes = basins.map do |pts|
  pts.each do |(i,j)|
    [[-1,0],[1,0],[0,-1],[0,1]].each do |(di,dj)|
      k, l = i+di, j+dj
      pts << [k,l] if k >= 0 && l >= 0 && k < lines.length && l < lines[k].length &&
                        lines[k][l] < 9 && !pts.include?([k,l])
    end
  end
  pts.size
end

puts "part2:", sizes.sort[-3..-1].reduce(&:*)
