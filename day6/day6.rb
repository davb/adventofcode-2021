fish = nil
File.foreach("input.txt") do |l|
  fish = l.scan(/\d+/).to_a.map(&:to_i)
end
(1..80).each do |n|
  newfish = []
  fish.map! do |t|
    if t == 0
      newfish << 8
      6
    else
      t - 1
    end
  end
  fish.concat(newfish)
  #puts "after #{n} days: #{fish.join(',')}"
end

# count points covered by 2 lines or more
puts "part1:", fish.size

