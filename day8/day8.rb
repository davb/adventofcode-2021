lines = File.foreach("input.txt").map{|l| l.scan(/\S+/).to_a.map(&:to_s)}.map do |l|
  a = l.take_while{|w| w != "|"}
  [a, l[a.size+1..-1]]
end

DIGITS = [
  "abcefg",
  "cf", # 2c = 1
  "acdeg",
  "acdfg",
  "bcdf", # 4c = 4
  "abdfg",
  "abdefg",
  "acf", # 3c = 7
  "abcdefg", # 7c = 8
  "abcdfg",
]

def digit code
  if [2,4,3,7].include?(code.length)
    return DIGITS.find{|d| d.length == code.length}
  end
end

score = 0
lines.each do |a, b|
  score += b.reduce(0){|s, c| s + (digit(c) ? 1 : 0)}
end
puts "part1:", score
