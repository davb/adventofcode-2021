lines = File.foreach("input.txt").map{|l| l.scan(/\d/).to_a.map(&:to_i)}

1.step do |s|
  lines.each_index{|i| lines[i].each_index{|j| lines[i][j] += 1} }
  flashing = true
  flashed = Hash.new(false)
  while flashing do 
    flashing = false
    lines.each_index do |i|
      lines[i].each_index do |j|
        if lines[i][j] > 9 && !flashed[[i, j]]
          flashing = true
          flashed[[i, j]] = true
          # increment adjacent
          [-1, 0, 1].each do |di|
            [-1, 0, 1].each do |dj|
              ii, jj = i+di, j+dj
              lines[ii][jj] += 1 if ii >= 0 && jj >= 0 && ii < 10 && jj < 10
            end
          end
        end
      end
    end
  end
  flashed.keys.each{|(i,j)| lines[i][j] = 0}
  if flashed.keys.length == 100 
    puts "part2:", s
    break
  end
end
