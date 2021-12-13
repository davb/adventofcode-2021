lines = File.foreach("input.txt").map{|l| l.scan(/\S+/).to_a.map(&:to_s)}
points, folds = lines.take_while{|l| !l.empty?}.map{|l| l.first.split(',').map(&:to_i)},
  lines.select{|l| l[0] == "fold"}.map{|f, a, cv| c, v = cv.split('='); [c, v.to_i]}

puts "part1:", folds.take(1).reduce(points){|p, (c, v)| p.map{|(x, y)| c == 'x' && x > v ? [v - (x - v), y] : (c == 'y' && y > v ? [x, v - (y - v)] : [x, y])}.uniq}.size

