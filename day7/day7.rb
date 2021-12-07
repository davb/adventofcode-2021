pos = nil
File.foreach("input.txt") do |l|
  pos = l.scan(/\d+/).to_a.map(&:to_i)
end
h = pos.reduce(Hash.new(0)){|h, p| h[p]+=1; h} # position => occurrences
bestP, bestC = nil, nil
h.each_pair.to_a.each do |(p0, freq)|
  c = h.each_pair.to_a.map{|(p, freq)| (p - p0).abs * freq}.sum
  bestP, bestC = p0, c if bestC.nil? || c < bestC
end
puts "part1:", bestP, bestC
