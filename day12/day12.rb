require 'set'
lines = File.foreach("input.txt").map{|l| l.scan(/\S+/).to_a.map(&:to_s)}

a = {}

a = lines.reduce({}) do |a, l|
  f, t = l.first.split('-')
  (a[f] ||= Set.new).add(t)
  (a[t] ||= Set.new).add(f)
  a
end

# returns all paths from f to t
def paths a, f, t, visited
  a[f].reduce([]) do |r, n|
    if !!/[A-Z]+/.match(n) || !visited.include?(n)
      if n == t
        r << [f, t]
      else
        paths(a, n, t, [n].concat(visited)).each{|p| r << [f].concat(p)}
      end
    end
    r
  end
end

puts "part1", paths(a, 'start', 'end', ['start']).size
