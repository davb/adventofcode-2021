# !/usr/bin/env ruby

class Cell
  def initialize v
    @v = v
    @drawn = false
  end

  def draw! d
    @drawn ||= @v == d
  end

  def drawn?
    @drawn
  end

  def score
    !@drawn ? @v : 0
  end

  def to_s
    "#{@v}#{@drawn ? "*" : " "}"
  end
end

class Board
  def initialize
    @rows = []
    @columns = []
  end

  def add_row r
    @rows << r.map{|x| Cell.new(x)}
    @rows.last.each_with_index do |v, i|
      @columns[i] ||= []
      @columns[i] << v
    end
  end

  def draw! d
    [@rows, @columns].each{|l| l.each{|r| r.each{|v| v.draw!(d)}}}
  end

  def won?
    @rows.any?{|r| r.all?(&:drawn?)} ||
      @columns.any?{|r| r.all?(&:drawn?)}
  end

  def score
    @rows.reduce(0){|s, r| s + r.reduce(0){|rs, v| rs + v.score}}
  end

  def to_s
    @rows.map{|r| r.map{|v| "#{v.to_s}"}.join(" ")}.join("\n")
  end

end

draw = nil
score = 0
boards = []
File.foreach("input.txt") do |l|
  row = l.scan(/\d+/).to_a.map(&:to_i)
  if !row.empty? && draw.nil?
    draw = row
  elsif row.empty?
    boards << Board.new
  else
    boards.last.add_row(row)
  end
end

won = false
draw.each do |d|
  boards.each do |b|
    b.draw!(d)
    if won = b.won?
      puts "winning board:", b, "score:", b.score, "last draw:", d
      score = b.score * d
    end
    break if won
  end
  break if won
end

puts "part1:", score
