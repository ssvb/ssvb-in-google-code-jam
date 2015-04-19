########################################################
# Crystal compiler 0.6.1 from http://crystal-lang.org/ #
# (statically typed language, based on Ruby syntax)    #
########################################################

PIXTHRESHOLD = 50
SUBZONETHRESHOLD = 16

def analyze_treelist(res, treelist, p1, p2, mincount)
    mup = (p2[1] - p1[1])
    mdown = (p2[0] - p1[0])
    bconst = p1[1] * mdown - p1[0] * mup
    if p2[0] == p1[0]
      treelist.each {|tree|
          if tree[0] < p1[0]
            res[0] += 1
            return if res[0] >= mincount && res[1] >= mincount
          elsif tree[0] > p1[0]
            res[1] += 1
            return if res[0] >= mincount && res[1] >= mincount
          end
      }
    elsif p2[1] == p1[1]
      treelist.each {|tree|
          if tree[1] < p1[1]
            res[0] += 1
            return if res[0] >= mincount && res[1] >= mincount
          elsif tree[1] > p1[1]
            res[1] += 1
            return if res[0] >= mincount && res[1] >= mincount
          end
      }
    else
      treelist.each {|tree|
        y = tree[0] * mup + bconst
        if y > tree[1] * mdown
            res[0] += 1
            return if res[0] >= mincount && res[1] >= mincount
        elsif y < tree[1] * mdown
            res[1] += 1
            return if res[0] >= mincount && res[1] >= mincount
        end
      }
    end
end

class ForestZone
  def initialize(treelist)
    xcoord = treelist.map {|pixel| pixel[0] }
    ycoord = treelist.map {|pixel| pixel[1] }
    x1 = xcoord.min
    y1 = ycoord.min
    x2 = xcoord.max
    y2 = ycoord.max
    @extents = [{x1, y1}, {x1, y2}, {x2, y1}, {x2, y2}]
    @treelist = treelist.shuffle
    @subzones = [] of ForestZone
    @scratch = [0, 0]
    if @treelist.size > PIXTHRESHOLD
      tmp = [@treelist]
      tmp.sort! {|a, b| b.size <=> a.size }
      while tmp[0].size > PIXTHRESHOLD && tmp.size < SUBZONETHRESHOLD
        tmplist = tmp.shift

        xcoord = tmplist.map {|pixel| pixel[0] }.sort
        ycoord = tmplist.map {|pixel| pixel[1] }.sort
        medianx = (xcoord.min + xcoord.max) / 2
        mediany = (ycoord.min + ycoord.max) / 2

        a = tmplist.select {|p| p[0] < medianx && p[1] < mediany}
        b = tmplist.select {|p| p[0] >= medianx && p[1] < mediany}
        c = tmplist.select {|p| p[0] < medianx && p[1] >= mediany}
        d = tmplist.select {|p| p[0] >= medianx && p[1] >= mediany}
        tmp.push(a) if a.size > 0
        tmp.push(b) if b.size > 0
        tmp.push(c) if c.size > 0
        tmp.push(d) if d.size > 0
        tmp.sort! {|a, b| b.size <=> a.size }
      end
      tmp.each {|treelist| @subzones.push(ForestZone.new(treelist)) }
      @subzones.shuffle!
    end
  end

  def analyze_zone(res, p1, p2, mincount)
    @scratch[0] = 0
    @scratch[1] = 0
    analyze_treelist(@scratch, @extents, p1, p2, mincount)
    if (@scratch[0] == 4 && @scratch[1] == 0) || ((@scratch[0] == 0 && @scratch[1] == 4))
      res[0] += @scratch[0] * @treelist.size / 4
      res[1] += @scratch[1] * @treelist.size / 4
      return
    end

    if @subzones.size > 0
      @subzones.each {|z|
        z.analyze_zone(res, p1, p2, mincount)
        return if res[0] >= mincount && res[1] >= mincount
      }
    else
      analyze_treelist(res, @treelist, p1, p2, mincount)
    end
  end
end

abort "Need input file name in the command line" if ARGV.size < 1

input = File.open(ARGV[0]).read.split.map {|x| x.to_i64 }

casenum = 1
t = input.shift

1.upto(t) {
  puts "Case ##{casenum}:"
  casenum += 1

  n = input.shift.to_i
  trees = [] of Tuple(Int64, Int64)
  1.upto(n) {|idx| trees.push({input.shift, input.shift}) }

  zone = ForestZone.new(trees)

  0.upto(n - 1) {|n1|
    mincount = n
    0.upto(n - 1) {|n2|
      next if n1 == n2

      p1 = trees[n1]
      p2 = trees[n2]

      res = [0, 0]
      zone.analyze_zone(res, p1, p2, mincount)

      mincount = [mincount, res.min].min
      break if mincount == 0
    }
    if n <= 3
      p 0
    else
      p mincount
    end
  }
}
