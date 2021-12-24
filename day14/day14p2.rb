t, rr = nil, {}
File.foreach("input.txt").map do |s, i|
  if /^[A-Z]+$/.match(s.to_s)
    t = s.to_s.scan(/\w/)
  elsif !s.to_s.strip.empty?
    p = s.to_s.strip.split(' -> ')
    p[0] = p.first.scan(/\w/)
    rr[p[0][0]] ||= {}
    rr[p[0][0]][p[0][1]] = p[1]
  end
end

# add terminal character so that each real character is at the start of a pair
t << '_'

# init pair counters
pair_counts = Hash.new(0)
t.each_index do |i|
  pair_counts[[t[i], t[i+1]]] += 1 if i+1 < t.length
end

(1..40).each do |s|
  nz_pairs = pair_counts.each_pair.select{|(x,y), c| c > 0}
  nz_pairs.each do |(x,y), n|
    if rr[x] && (z = rr[x][y])
      # apply "X,Y -> Z": remove all (X-Y) pairs (=N) and create N (X-Z) and (Z-Y) pairs
      pair_counts[[x,y]] -= n
      pair_counts[[x,z]] += n
      pair_counts[[z,y]] += n
    end
  end
end

# count how many times each character is at the start of a pair (works due to terminal character)
freq = pair_counts.reduce(Hash.new(0)){|h, ((x, y), c)| h[x] += c; h}.each_pair.sort_by(&:last)
puts "part2:", freq.last.last - freq.first.last
