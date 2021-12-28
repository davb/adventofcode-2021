class Game

  def initialize p1, p2, dice
    @dice = dice
    @u = Hash.new(0)
    @u[[[p1,p2],[0,0]]] = 1
    @p = 0
  end

  def play!
    r = @dice.roll
    w,t = [0,0],0
    u = Hash.new(0)
    @u.keys.each do |k|
      nu = @u[k] # number of copies of this universe
      if k.last.max < 21
        # this universe is playable and splits
        u[k] -= nu
        r.each do |d, n|
          l, s = *k.dup.map(&:dup)
          l[@p] += d % 10
          l[@p] -= 10 if l[@p] > 10
          s[@p] += l[@p]
          u[[l,s]] += nu * n
          t += nu * n
        end
      else
        # game has been won in this universe
        w[0] += nu if k.last[0] >= 21
        w[1] += nu if k.last[1] >= 21
        t += nu
      end
    end
    u.each do |k, n|
      @u[k] += n
      @u.delete(k) if @u[k] == 0
    end
    @p = 1 - @p
    return play! if w.sum < t # play until game ends in all universes
    w.max
  end

end


class DiracDice
  def roll
    @roll ||= begin
      v=[1,2,3]
      c=v.reduce([]){|l,i| v.reduce(l){|l,j| v.reduce(l){|l,k| l.push(i+j+k)}}}
      c.reduce(Hash.new(0)){|h,i| h[i]+=1; h}
    end
  end
end

g=Game.new(6, 10, DiracDice.new)
puts "part2:", g.play!

