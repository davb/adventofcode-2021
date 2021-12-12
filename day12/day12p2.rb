require 'set'
lines = File.foreach("input.txt").map{|l| l.scan(/\S+/).to_a.map(&:to_s)}

a = lines.reduce({}) do |a, l|
  f, t = l.first.split('-')
  (a[f] ||= Set.new).add(t)
  (a[t] ||= Set.new).add(f)
  a
end

# returns all paths from f to t
def paths a, f, t, visited
  lvisited = visited.select{|v| /[a-z]+/.match(v)}
  twosmallvisited = lvisited.uniq.size < lvisited.size
  a[f].reduce([]) do |r, n|
    if /[A-Z]+/.match(n) || visited.select{|v| v == n}.size < (n == 'start' || n == 'end' || twosmallvisited ? 1 : 2)
      if n == t
        r << [f, t]
      else
        paths(a, n, t, [n].concat(visited)).each{|p| r << [f].concat(p)}
      end
    end
    r
  end
end

puts "part2:", paths(a, 'start', 'end', ['start']).size
