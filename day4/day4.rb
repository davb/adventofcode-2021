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
    @won = false
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
    @won ||= [@rows, @columns].any?{|l| l.any?{|r| r.all?(&:drawn?)}}
  end

  def score
    @rows.reduce(0){|s, r| s + r.reduce(0){|rs, v| rs + v.score}}
  end

  def to_s
    @rows.map{|r| r.map{|v| "#{v.to_s}"}.join(" ")}.join("\n")
  end

end

draw = nil
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

draw.each do |d|
  remaining = boards.reject(&:won?)
  break if remaining.empty?
  remaining.each do |b|
    b.draw!(d)
    if b.won?
      if remaining.size == boards.size
        # first board to win
        puts "last winning board:", b, "score:", b.score, "last draw:", d
        puts "part1:", b.score * d
      end
      if remaining.size == 1
        # last remaining board just won
        puts "last winning board:", b, "score:", b.score, "last draw:", d
        puts "part2:", b.score * d
      end
    end
  end
end


