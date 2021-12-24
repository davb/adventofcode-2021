require 'json'
nums = File.foreach("input.txt").map{|l| JSON.parse(l)}

class Node
  attr_accessor :l
  attr_accessor :r
  attr_accessor :v

  def initialize v, l, r
    self.v = v
    self.l = l
    self.r = r
  end

  def v= x
    @v = x
    if !x.nil? then @l = nil; @r = nil end # turn to leaf
  end

  def self.from x
    if x.kind_of?(Array)
      return Node.new(nil, Node.from(x[0]), Node.from(x[1]))
    elsif x.kind_of?(Integer)
      return Node.new(x, nil, nil)
    end
    raise "can't create Node from #{x.inspect}"
  end

  def to_s
    @v ? "#{@v.to_s}" : "[#{@l},#{@r}]"
  end

  def +(other)
    Node.new(nil, self.clone, other.clone).reduce!
  end

  def clone
    Node.new(@v.clone, @l.clone, @r.clone)
  end

  def mag
    @v ? @v : (@l.mag * 3 + @r.mag * 2)
  end

  # depth-first traversal with prefix numbering and depth
  def traverse i=0, d=0, &block
    block.call(self, i, d) if block_given?
    i = @l ? @l.traverse(i+1, d+1, &block) : i
    @l ? @r.traverse(i+1, d+1, &block) : i
  end

  def reduce!
    # look for splittable and explodable nodes
    s, e, ei, ep, en = nil, nil, nil, nil, nil
    traverse do |n, i, d|
      if n.v
        s ||= n if n.v && n.v >= 10 # splittable leaf
        ep = n if !e # last leaf before exploable pair
        en ||= n if e && i > ei + 2 # 1st leaf after exploable pair
      elsif d >= 4 && !e
        e = n # explodable pair
        ei = i
      end
    end
    # explode pair e or split leaf s
    if e
      ep.v += e.l.v unless ep.nil?
      en.v += e.r.v unless en.nil?
      e.v = 0
      return reduce!
    elsif s
      s.l = Node.new(s.v / 2, nil, nil)
      s.r = Node.new(s.v / 2 + s.v % 2, nil, nil)
      s.v = nil
      return reduce!
    end
    self
  end

end

nums.map!{|n| Node.from(n)}
max = 0
nums.each_index do |i|
  nums.each_index do |j|
    max = [max, (nums[i] + nums[j]).mag].max if j != i
  end
end
puts "part2", max
