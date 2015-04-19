########################################################
# Crystal compiler 0.6.1 from http://crystal-lang.org/ #
# (statically typed language, based on Ruby syntax)    #
########################################################

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

  0.upto(n - 1) {|n1|
    mincount = n
    0.upto(n - 1) {|n2|
      next if n1 == n2

      p1 = trees[n1]
      p2 = trees[n2]
      res = [0, 0]

      if p2[0] == p1[0]
        trees.each_with_index {|tree, idx|
          next if n1 == idx || n2 == idx
          if tree[0] < p1[0]
            res[0] += 1
            break if res[0] >= mincount && res[1] >= mincount
          elsif tree[0] > p1[0]
            res[1] += 1
            break if res[0] >= mincount && res[1] >= mincount
          end
        }
      else
        # line equation: y = m * x + b
        mup = (p2[1] - p1[1])
        mdown = (p2[0] - p1[0])
        bconst = p1[1] * mdown - p1[0] * mup

        trees.each_with_index {|tree, idx|
          next if idx == n1
          next if idx == n2
          y = tree[0] * mup + bconst
          if y > tree[1] * mdown
            res[0] += 1
            break if res[0] >= mincount && res[1] >= mincount
          elsif y < tree[1] * mdown
            res[1] += 1
            break if res[0] >= mincount && res[1] >= mincount
          end
        }
      end

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
