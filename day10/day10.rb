lines = File.foreach("input.txt").map{|l| l.scan(/\S/).to_a.map(&:to_s)}

CHARS = ["(", ")","[", "]","<", ">","{", "}"]

def opening? c
  CHARS.find_index(c) % 2 == 0
end

def matches? open, close
  CHARS[CHARS.find_index(open) + 1] == close
end

score = 0
lines.each do |l|
  stack = []
  l.each do |c|
    if opening?(c)
      stack << c
    else
      k = stack.pop()
      if !matches?(k, c)
        score += {
          ")" => 3,
          "]" => 57,
          "}" => 1197,
          ">" => 25137,
        }[c]
        break
      end
    end
  end
end

puts "part1:", score
