alg, img = *File.foreach("input.txt")
  .map{|l| l.scan(/[\.#]/).map{|c| c == "." ? 0 : 1}}
  .reduce([nil, []]){|ac, l| a, i = *ac; l.empty? ? [a, i] : (!a ? [l, i] : [a, i.push(l)])}


def ninepx j, i
  (-1..1).reduce([]){|l, dj| l + (-1..1).map{|di| [j+dj, i+di]}}
end


def bin2dec bin
  bin.each_with_index.reduce(0){|s, (d, i)| s + d * 2**(bin.size-i-1)}
end


class Image

  # takes an Array of (x,y) "lit" pixels and a background "dark" color
  def initialize nobg, bg=0
    @nobg = nobg; @bg = bg;
  end

  def self.from_matrix m
    self.new m.each_index.reduce({}){|h, j| m[j].each_index{|i| (m[j][i] == 1) && (h[[j,i]] = 1)}; h}
  end

  def [](j, i)
    @nobg[[j,i]] ? (1-@bg) : @bg
  end

  def bounds
    min = @nobg.keys.reduce{|mk, k| k.zip(mk).map(&:min)}
    max = @nobg.keys.reduce{|mk, k| k.zip(mk).map(&:max)}
    [min, max] # [[jmin, imin], [jmax, imax]]
  end

  def to_s
    ((jmin, imin), (jmax, imax)) = self.bounds
    (jmin..jmax).map{|j| (imin..imax).map{|i| self[j,i] == @bg ? '.' : '#'}.join}.join("\n")
  end

  def apply alg
    bg = @bg == 0 ? alg[0] : alg[511]
    pad = 2 # 2px padding for contribution of edge pixels
    ((jmin, imin), (jmax, imax)) = self.bounds
    nobg = (jmin-pad..jmax+pad).reduce({}) do |nobg, j|
      (imin-pad..imax+pad).each do |i|
        bin = ninepx(j, i).map{|(j, i)| self[j,i]}
        nobg[[j,i]] = 1 if alg[bin2dec(bin)] != bg
      end
      nobg
    end
    Image.new(nobg, bg)
  end

  def lit
    @nobg.keys.length
  end
end


i = Image.from_matrix(img)
(1..50).each do
  i = i.apply(alg)
end
puts "part2:", i.to_s, i.lit
