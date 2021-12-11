lines = File.foreach("input.txt").map{|l| l.scan(/\S/).to_a.map(&:to_s)}

CHARS = ["(", ")","[", "]","<", ">","{", "}"]

def opening? c
  CHARS.find_index(c) % 2 == 0
end

def closing_for open
  CHARS[CHARS.find_index(open) + 1]
end

def matches? open, close
  closing_for(open) == close
end

p1score, p2scores = 0, []
lines.each do |l|
  stack, illegal, line_score = [], false, 0
  l.each do |c|
    if opening?(c)
      stack << c
    else
      k = stack.pop()
      if illegal = !matches?(k, c)
        p1score += {")" => 3, "]" => 57, "}" => 1197, ">" => 25137}[c]
        break
      end
    end
  end
  # end of line
  if !illegal
    rest = stack.reverse.map{|c| closing_for(c)}
    line_score = rest.reduce(0){|ls, k| ls * 5 + {")" => 1, "]" => 2, "}" => 3, ">" => 4}[k] }
    p2scores << line_score
  end
end

puts "part1:", p1score
puts "part2:", p2scores.sort[p2scores.size / 2]
