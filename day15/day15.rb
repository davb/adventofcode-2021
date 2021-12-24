t = File.foreach("input.txt").map{|l| l.scan(/\d/).map(&:to_i)}

def explore t
  # destination
  x2, y2 = t.first.size-1, t.size-1
  # edge = unexplored locations
  edge = [[0, 0]]
  # at any time mem[x][y] stores the shortest path from [0,0] to [x,y], as ([px,py], cost)
  # where (px,py) is the previous point in the shortest path, and cost is the path's cost
  mem = t.map{|r| r.map{|c| nil}}
  mem[0][0] = [nil, 0] # start location is explored at no cost
  # explore the input
  1.step do |i|
    x1, y1 = edge.pop
    [[0,1],[1,0],[0,-1],[-1,0]].each do |(dx, dy)|
      xa, ya = x1 + dx, y1 + dy
      if xa >= 0 && ya >= 0 && ya < t.size && xa < t[ya].size
        cost = mem[x1][y1].last + t[xa][ya]
        if !mem[xa][ya] || mem[xa][ya].last > cost
          mem[xa][ya] = [[x1, y1], cost]
          edge << [xa, ya] unless edge.include?([xa,ya])
        end
      end
    end
    edge.sort_by!{|(x,y)| -mem[x][y].last}
    break if edge.empty? || edge[0] == [x2, y2]
  end
  # return cost of the shortest path
  mem[x2][y2].last
end

puts "part1", explore(t)
