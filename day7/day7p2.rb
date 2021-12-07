pos = File.read("input.txt").scan(/\d+/).to_a.map(&:to_i)
h = pos.reduce(Hash.new(0)){|h, p| h[p]+=1; h} # position => occurrences
bestP, bestC = nil, nil
(0..pos.max).each do |p0|
  # the fuel cost for n distance is n*(n+1)/2
  c = h.each_pair.to_a.map{|(p, freq)| n = (p - p0).abs; n*(n+1)/2 * freq}.sum
  bestP, bestC = p0, c if bestC.nil? || c < bestC
end
puts "part2:", bestP, bestC
