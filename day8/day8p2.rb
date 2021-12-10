lines = File.foreach("input.txt").map{|l| l.scan(/\S+/).to_a.map(&:to_s)}.map do |l|
  a = l.take_while{|w| w != "|"}
  [a, l[a.size+1..-1]]
end

def common a, b
  (a.scan(/\w/) & b.scan(/\w/)).size
end

score = 0
lines.each do |a, b|
  d = [nil] * 9
  # find uniques
  d[1] = a.find{|c| c.length == 2}
  d[4] = a.find{|c| c.length == 4}
  d[7] = a.find{|c| c.length == 3}
  d[8] = a.find{|c| c.length == 7}
  # 3 has 5 segments including those of 1
  d[3] = a.find{|c| c.length == 5 && common(c, d[1]) == 2}
  # 9 has 6 segments including those of 4
  d[9] = a.find{|c| c.length == 6 && common(c, d[4]) == 4}
  # 5 also has 5 segments including 4 in common with 3 and 3 with 4
  d[5] = a.find{|c| c.length == 5 && c != d[3] && common(c, d[3]) == 4 && common(c, d[4]) == 3}
  # 2 also has 5 segments
  d[2] = a.find{|c| c.length == 5 && c != d[3] && c != d[5]}
  # 6 also has 6 segments including those of 5
  d[6] = a.find{|c| c.length == 6 && c != d[9] && common(c, d[5]) == 5}
  # 0 also has 6 segments
  d[0] = a.find{|c| c.length == 6 && c != d[9] && c != d[6]}
  # done! now resolve the output
  score += b.map{|c| d.find_index{|k| c.size == k.size && c.size == common(c, k)}}.join.to_i
end
puts "part2:", score
