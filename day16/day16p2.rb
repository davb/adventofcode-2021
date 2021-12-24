hs = File.foreach("input.txt").map{|l| l.scan(/\w/).map(&:to_s)}

LITERAL = 4

bits = hs.map do |h|
  h.map{|h| h.hex.to_s(2).rjust(4, "0").scan(/\d/)}.flatten.map(&:to_i)
end

# [1,1,0] > 6
def to_dec bits
  bits.each_with_index.reduce(0){|d, (b, i)| d + b * 2**(bits.size - 1 - i)}
end

def read b
  i, ver, typ, eop, val, pacs = 0, nil, nil, false, [], []
  ltyp, lpac, npac = nil, nil, nil

  loop do
    if !eop && i + 3 > b.size
      raise "bad format #{b[i..-1].join}"
    elsif ver.nil?
      ver = to_dec(b[i, 3])
      i += 3
    elsif typ.nil?
      typ = to_dec(b[i, 3])
      i += 3
    elsif typ == LITERAL
      if eop || i + 5 > b.size
        break
      else
        g = b[i, 5]
        eop = g[0] == 0
        val.concat(g[1, 4])
        i += 5
      end
    else # operator
      if ltyp.nil?
        ltyp = b[i]
        i += 1
      elsif ltyp == 0
        if lpac.nil?
          lpac = to_dec(b[i, 15])
          i += 15
        else
          # read lpac bits as packets
          while lpac > 0 do
            pacs << read(b[i, lpac])
            i += pacs.last[:len]
            lpac -= pacs.last[:len]
          end
          break
        end
      elsif ltyp == 1
        if npac.nil?
          npac = to_dec(b[i, 11])
          i += 11
        else
          # read npac packets in remaining bits
          while pacs.size < npac do
            pacs << read(b[i..-1])
            i += pacs.last[:len]
          end
          break
        end
      end
    end
  end
  res = {ver: ver, typ: typ, len: i}
  if typ == LITERAL then res[:val] = to_dec(val) else res[:pacs] = pacs end
  return res
end

def eval p
  return p[:val] if (t = p[:typ]) == LITERAL
  pacs = p[:pacs].map{|p| eval(p)}
  return pacs.reduce(0, :+) if t == 0
  return pacs.reduce(1, :*) if t == 1
  return pacs.min if t == 2
  return pacs.max if t == 3
  return pacs[0] > pacs[1] ? 1 : 0 if t == 5
  return pacs[0] < pacs[1] ? 1 : 0 if t == 6
  return pacs[0] == pacs[1] ? 1 : 0 if t == 7
  raise "bad type #{t}"
end

puts "part2:"
bits.each{|b| puts(eval(r=read(b)))}
