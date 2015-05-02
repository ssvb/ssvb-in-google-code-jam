########################################################
# Crystal compiler 0.6.1 from http://crystal-lang.org/ #
# (statically typed language, based on Ruby syntax)    #
########################################################

abort "Need input file name in the command line" if ARGV.size < 1

def reverse(a)
  a.to_s.reverse.to_i64
end

def nested_countdown_count(n_str, cost_dec)
  highdigit = n_str[0].ord - '0'.ord
  lowdigit = n_str[-1].ord - '0'.ord
  cost = cost_dec.to_i64 * lowdigit
  flipcount = 0.to_i64
  if n_str.size >= 2
    if highdigit > 0
      if n_str.size > 2
        xcost, xflipcount = nested_countdown_count(n_str[1 .. -2].reverse, cost_dec * 10)
        cost += xcost
        flipcount += xflipcount
      end
      cost += highdigit * cost_dec
      if flipcount == 0
        cost += 1
        flipcount += 1
      end
    else
      if n_str.size > 2
        xcost, xflipcount = nested_countdown_count(n_str[1 .. -2], cost_dec * 10)
        cost += xcost
        flipcount += xflipcount
      end
    end
  end
  return cost, flipcount
end

def countdown_count(n, cost_dec)
  count = 1.to_i64
  while true
    break if n == 1
    lowdigit = n % 10
    highdigit = n
    while highdigit > 9
      highdigit /= 10
    end

    if lowdigit == 0
      count += cost_dec
      n = n - 1
      next
    end

    n_str = n.to_s
    if n_str.size > 2
      count_upd, flipcount_upd = nested_countdown_count(n_str[1 .. -2], 10)
      count += count_upd
      new_n = 1.to_i64
      1.upto(n_str.size - 1) { new_n *= 10 }
      n = new_n + 1
      if flipcount_upd > 0 || highdigit == 1
        count += ((lowdigit - 1) + (highdigit - 1)) * cost_dec
      else
        count += ((lowdigit - 1) + (highdigit - 1)) * cost_dec + 1
      end

      count += cost_dec
      n = n - 1
      next
    end

    if highdigit != 1 && lowdigit == 1 && n_str.size == 2
      count += 1
      n = reverse(n)
    else
      count += cost_dec
      n = n - 1
    end

  end
  return count
end

input = File.open(ARGV[0]).read.split.map { |x| x.to_i64 }
input.shift.times { |i| puts "Case ##{i + 1}: #{countdown_count(input.shift, 1)}" }
