fish = nil
File.foreach("input.txt") do |l|
  fish = l.scan(/\d+/).to_a.map(&:to_i)
end
fish = fish.reduce(Array.new(9, 0)){|a, c| a[c] += 1; a}
(1..256).each do |n|
  newfish = fish[0]
  (0..7).each{|i| fish[i] = fish[i+1]}
  fish[8] = newfish
  fish[6] += newfish
  puts "after #{n} days: #{fish.sum}" if n % 1 == 0
end
puts "part2:", fish.sum
