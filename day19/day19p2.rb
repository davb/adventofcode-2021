scanners = File.foreach("input.txt").reduce([]) do |s, l|
  if /^--/.match(l)
    s << []
  elsif /^-?\d+/.match(l)
    s.last << l.split(',').map(&:to_i)
  end
  s
end

OVERLAP = 12


def p_add p1, p2
  p1.zip(p2).map{|x1, x2| x2 + x1}
end

def p_diff p1, p2
  p1.zip(p2).map{|x1, x2| x2 - x1}
end


class Vector
  attr_reader :a
  attr_reader :b
  attr_reader :c

  def initialize a, b
    @a = a; @b = b; @c = p_diff(@a, @b)
  end

  def eql?(other); self.c == other.c; end
  def hash; self.c.hash; end
  def to_s; "(#{a})->(#{b})"; end
end


class Scanner
  attr_reader :id
  attr_reader :rot
  attr_reader :offset

  def initialize id, pts, rot=0, offset=[0,0,0]
    @id = id; @pts = pts; @rot=rot; @offset=offset
  end

  def points
    xo, yo, zo = *@offset
    r1, r2, r3 = @rot/8, (@rot%8)/2, (@rot%8)%2
    return @pts.map do |x, y, z|
      # pick rotation axis
      x, y, z = *[
        [x, y, z],
        [x, z, -y],
        [z, y, -x],
      ][r1]
      # rotate around z axis
      x, y, z = *[
        [x, y, z],
        [-y, x, z],
        [-x, -y, z],
        [y, -x, z],
      ][r2]
      # up or down on rotation axis
      x, y, z = *[
        [x, y, z],
        [-x, y, -z],
      ][r3]
      [x + xo, y + yo, z + zo]
    end
  end

  def rotation rot
    Scanner.new(@id, @pts, rot, @offset)
  end

  def next_rotation
    @rot < 23 ? rotation(@rot + 1) : nil
  end

  def vectors
    (pts = self.points).reduce([]) do |v, a|
      pts.each do |b|
        v << Vector.new(a, b) if a != b
      end
      v
    end
  end

  def v_off v1, v2
    p_diff(v1.a, v2.a)
  end

  def common_vectors other
    vs1 = self.vectors
    vs2 = other.vectors
    return [] if (vs1 & vs2).size < OVERLAP
    pairings = vs1.each_index.map do |i|
      pairs = []
      pi = {}
      off = nil
      vs1.each_index do |j|
        k = (i + j) % vs1.size
        v1 = vs1[k]
        vs2.each_with_index do |v2, l|
          if !pi[l] && v2.c == v1.c && (off.nil? || v_off(v1, v2) == off)
            pairs << [v1, v2]
            off ||= v_off(v1, v2)
            pi[l] = true
            break
          end
        end
      end
      return pairs if pairs.size >= OVERLAP * 2
      pairs
    end
    return pairings.sort_by(&:size).last
  end

  def align_with! ref
    v_ref = ref.vectors
    r = self
    until r.nil?
      v = r.vectors
      int = r.common_vectors(ref)
      if int.size >= OVERLAP * (OVERLAP - 1)
        @rot = r.rot
        @offset = p_add(r.offset, v_off(int.first.first, int.first.last))
        puts "aligned #{id} with #{ref.id}: rot=#{@rot} off=#{@offset} (#{int.size} matches)"
        return true
      end
      r = r.next_rotation
    end
    return false
  end

  def to_s
    "<Scanner:#{@id} n=#{@pts.size} r=#{@rot} o=#{offset.join(',')}>"
  end
end

sc = scanners.each_with_index.map{|pts, i| Scanner.new(i, pts)}

# align all scanners with scanner 0
aligned = [sc.shift]
while (s = sc.shift)
  sc.push(s) unless aligned.each_with_index.any? do |rs|
    if s.align_with!(rs)
      aligned << s
    end
  end
end

puts "part1:"
puts aligned.map(&:points).reduce(:+).uniq.size


def manhattan s1, s2
  p_diff(s1.offset, s2.offset).map(&:abs).sum
end

puts "part2:"
puts aligned.map{|s1| aligned.map{|s2| manhattan(s1, s2)}.max}.max
