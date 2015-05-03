########################################################
# Crystal compiler 0.6.1 from http://crystal-lang.org/ #
# (statically typed language, based on Ruby syntax)    #
########################################################

abort "Need input file name in the command line" if ARGV.size < 1

def slow_encounters(arrival_times, t)
  lo = 0
  hi = arrival_times.size - 1

  return arrival_times.size if t < arrival_times[lo]
  return 0 if t > arrival_times[hi]

  while true
    mid = (lo + hi) / 2
    if t < arrival_times[mid]
      hi = mid
    end
    if t > arrival_times[mid]
      lo = mid
    end
    if hi - lo == 1
      return arrival_times.size - hi
    end
  end
end

def fast_encounters(starting_pos, time_per_loop, t, limit)
  count = 0
  n = starting_pos.size
  n.times { |i|
    extra_loops = (t * 360 + (starting_pos[i] - 360.to_i64) * time_per_loop[i]) / (360.to_i64 * time_per_loop[i])
    while true
      arrival_time = (360.to_i64 * extra_loops + 360.to_i64 - starting_pos[i]) * time_per_loop[i] / 360
      if arrival_time >= t
        break
      end
      extra_loops += 1
    end
    while true
      arrival_time = (360.to_i64 * extra_loops + 360.to_i64 - starting_pos[i]) * time_per_loop[i] / 360
      if arrival_time < t
        break
      end
      extra_loops -= 1
    end
    if extra_loops >= 1
      count += extra_loops
    end
    return limit if count >= limit
  }
  return count
end

input = File.open(ARGV[0]).read.split.map { |x| x.to_i64 }
input.shift.times { |i|
  n = input.shift
  starting_pos = [] of Int64
  time_per_loop = [] of Int64
  n.times {
    d, h, m = input.shift(3)
    h.times { |incr|
      starting_pos.push(d)
      time_per_loop.push((m + incr) * 720)
    }
  }
  n = starting_pos.size

  arrival_times = [] of Int64
  n.times { |i|
    arrival_times.push((360.to_i64 - starting_pos[i]) * time_per_loop[i] / 360)
  }
  arrival_times.sort!

  limit = slow_encounters(arrival_times, 0)

  best_idx = 0
  best_encounters = limit

  (0 .. arrival_times.size - 1).step(500) { |idx|
    t = arrival_times[idx]
    encounters = slow_encounters(arrival_times, t + 1) +
                 fast_encounters(starting_pos, time_per_loop, t + 1, limit)
    if encounters < best_encounters
      best_encounters = encounters
      best_idx = idx
    end
  }

  minidx = [best_idx - 500, 0].max
  maxidx = [best_idx + 500, arrival_times.size - 1].min

  minidx.upto(maxidx) { |idx|
    t = arrival_times[idx]
    encounters = slow_encounters(arrival_times, t + 1) +
                 fast_encounters(starting_pos, time_per_loop, t + 1, limit)
    if encounters < best_encounters
      best_encounters = encounters
      best_idx = idx
    end
  }

  puts "Case ##{i + 1}: #{best_encounters}"
}
