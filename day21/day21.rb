class Game

  def initialize p1, p2, dice
    @l=[p1, p2]; @dice=dice
  end

  def play!
    @s = [0,0]
    @p = 0
    r = 0
    until @s.max >= 1000 do
      d = [@dice.roll,@dice.roll,@dice.roll]
      r += 3
      @l[@p] += d.sum % 10
      @l[@p] = @l[@p] -= 10 if @l[@p] > 10
      @s[@p] += @l[@p]
      @p = 1 - @p
    end
    r * @s.min
  end

end


class DetDice
  def roll
    @v = (@v ||= 0) >= 100 ? 1 : @v+1
  end
end

g = Game.new(6, 10, DetDice.new)
puts "part1:", g.play!

