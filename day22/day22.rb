input = File.foreach("input.txt")
  .map{|l| /(on|off).*?(-?\d+).*?(-?\d+).*?(-?\d+).*?(-?\d+).*?(-?\d+).*?(-?\d+).*?/.match(l)}
  .map{|m| [m[1]] + m[2..7].map(&:to_i)}


class Cuboid
  attr_reader :b
  attr_reader :st

  def initialize state, x, y, z
    @st = state
    @b = [x, y, z]
    @c = nil
  end

  # returns a new cuboid with dimension #i replaced with v
  def set dim, v
    Cuboid.new(@st, *@b.each_with_index.map{|b, d| d == dim ? v.dup : b.dup})
  end

  def intersects? cub
    !@b.zip(cub.b).all?{|((x1,x2),(o1,o2))| x2 < o1 || o2 < x1}
  end

  def inside? cub
    @b.zip(cub.b).all?{|((x1,x2),(o1,o2))| o1 <= x1 && x2 <= o2}
  end

  def intersect! cub
    # if no overlap, return immediately
    return false unless self.intersects?(cub)
    # if this cuboid is split, intersect with each child
    return @c.map{|c| c.intersect!(cub)}.any? if @c
    # in each dimension, split this cuboid in 2 or 3 if it overlaps with cub
    cub.b.each_with_index do |(x1, x2), dim|
      (b1, b2) = @b[dim]
      if x1 <= b1 && b1 <= x2 && x2 < b2
        # split along right side of cub
        @c = [self.set(dim, [b1, x2]), self.set(dim, [x2+1, b2])]
      elsif b1 < x1 && x1 <= b2 && b2 <= x2
        # split along left side of cub
        @c = [self.set(dim, [b1, x1-1]), self.set(dim, [x1, b2])]
      elsif b1 < x1 && x2 < b2
        # split along both sides of cub
        @c = [self.set(dim, [b1, x1-1]), self.set(dim, [x1, x2]), self.set(dim, [x2+1, b2])]
      end
      # recursion to split along other dimensions
      return self.intersect!(cub) if @c
    end
    # update state if this cuboid is entirely contained in cub
    @st = cub.st if inside?(cub)
    return true
  end

  def vol; @c ? @c.map(&:vol).sum : @b.map{|x1, x2| x2 + 1 - x1}.reduce(:*); end
  def vol_on; @c ? @c.map(&:vol_on).sum : (@st == 'on' ? vol : 0); end
end


area = Cuboid.new('off', [-50, 50], [-50, 50], [-50, 50])
input.each{|(state, x1, x2, y1, y2, z1, z2)| area.intersect!(Cuboid.new(state, [x1, x2], [y1, y2], [z1, z2]))}
puts "part1:", area.vol_on
