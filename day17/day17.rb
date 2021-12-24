target = File.read("input.txt").scan(/x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/).first.map(&:to_i)

def simulate vx, vy, (x1, x2, y1, y2)
  x, y, ymax = 0, 0, 0
  xb, yb = [x1, x2].max, [y1, y2].min
  loop do
    x, y, vx, vy = x + vx, y + vy, vx - (vx > 0 ? 1 : (vx == 0 ? 0 : -1)), vy - 1
    ymax = [y, ymax].max
    if x >= x1 && x <= x2 && y >= y1 && y <= y2
      return ymax
    elsif x > xb || y < yb
      return nil
    end
  end
end

vxm, vym, ymax = 0, 0, 0
(-500..500).each do |vx|
  (-500..500).each do |vy|
    if (s = simulate(vx, vy, target)) && s > ymax
      vxm, vym, ymax = vx, vy, s
    end
  end
end

puts "part1:", ymax
