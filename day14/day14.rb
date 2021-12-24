t, r = nil, []
rr = {}
File.foreach("input.txt").map do |s, i|
  if /^[A-Z]+$/.match(s.to_s)
    t = s.to_s.scan(/\w/)
  elsif !s.to_s.strip.empty?
    p = s.to_s.strip.split(' -> ')
    p[0] = p.first.scan(/\w/)
    r << p
    rr[p[0][0]] ||= {}
    rr[p[0][0]][p[0][1]] = p[1]
  end
end

(1..10).each do |s|
  i = 0
  loop do
    if i < t.size-1 && rr[t[i]] && (n = rr[t[i]][t[i+1]])
      t = t[0..i].concat([n]).concat(t[i+1..-1])
      i += 1
      #puts 'ins', n, rr[t[i]][t[i+1]], t.to_s
    end
    i += 1
    #puts i, t.size
    break if i >= t.size-1
  end
  #puts 'step', s, t.size
end

freq = t.reduce(Hash.new(0)){|h, c| h[c] += 1; h}.each_pair.sort_by(&:last)

puts "part1:", freq.last.last - freq.first.last
