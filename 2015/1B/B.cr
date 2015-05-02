########################################################
# Crystal compiler 0.6.1 from http://crystal-lang.org/ #
# (statically typed language, based on Ruby syntax)    #
########################################################

abort "Need input file name in the command line" if ARGV.size < 1

def test_checkerboard(w, h, n, pattern)
  board = [] of Array(Bool)
  noise = 0
  count = 0

  # checkerboard pattern (zero noise)
  0.upto(h - 1) { |y|
    row = [] of Bool
    1.upto(w) { row.push(false) }
    board.push(row)
    0.upto(w - 1) { |x|
      if (x + y) % 2 == pattern
        board[y][x] = true
        count += 1
        return noise if count >= n
      end
    }
  }

  # corners (noise = 2)
  [0, h - 1].uniq.each { |y|
    [0, w - 1].uniq.each { |x|
      if !board[y][x]
        board[y][x] = true
        count += 1
        noise += h > 1 ? 2 : 1
        return noise if count >= n
      end
    }
  }

  # edges (noise = 3)
  0.upto(h - 1) { |y|
    [0, w - 1].uniq.each { |x|
      if !board[y][x]
        board[y][x] = true
        count += 1
        noise += h > 1 ? 3 : 2
        return noise if count >= n
      end
    }
  }
  [0, h - 1].uniq.each { |y|
    0.upto(w - 1) { |x|
      if !board[y][x]
        board[y][x] = true
        count += 1
        noise += h > 1 ? 3 : 2
        return noise if count >= n
      end
    }
  }

  # everything else (noise = 4)
  return noise + (n - count) * (h > 1 ? 4 : 2)
end

input = File.open(ARGV[0]).read.split.map { |x| x.to_i }
input.shift.times { |i|
  r, c, n = input.shift(3)
  c, r = r, c if r > c
  result = [test_checkerboard(c, r, n, 0), test_checkerboard(c, r, n, 1)].min
  puts "Case ##{i + 1}: #{result}"
}
