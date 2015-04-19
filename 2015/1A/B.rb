#!/usr/bin/env ruby

abort "Need input file name in the command line" if ARGV.size < 1

input = File.open(ARGV[0]).read.split.map {|x| x.to_i }

casenum = 1
t = input.shift

1.upto(t) {
  b = input.shift
  n = input.shift
  barbers = input.shift(b)

  # calculate a huge fraction
  total_speed_top = 0
  total_speed_bot = 1
  barbers.each {|bt| total_speed_bot *= bt }
  barbers.each {|bt| total_speed_top += total_speed_bot / bt }

  # pick some reasonable timestamp in the past
  timestamp_top = total_speed_bot * [n - b - 1, 0].max
  timestamp_bot = total_speed_top

  while true
    seated_customers = barbers.map {|bt|
      top = timestamp_top
      bot = timestamp_bot * bt
      ((top + bot - 1) / bot).to_s.to_i
    }
    seated_customers_total = 0
    seated_customers.each {|x| seated_customers_total += x }

    minute_when_free = seated_customers.map.with_index {|seated_cnt, idx|
      seated_cnt * barbers[idx]
    }
    # one or more barbers will be free at this minute
    next_timestamp = minute_when_free.min
    slots_on_next_timestamp = minute_when_free.map.with_index {|val, idx|
      [val, idx]
    }.select {|val| val[0] == next_timestamp }.map {|val| val[1] }

    # check if n-th customer can be served as part of this batch
    if seated_customers_total < n && seated_customers_total + slots_on_next_timestamp.size >= n
      result = slots_on_next_timestamp[n - seated_customers_total - 1] + 1
      puts "Case ##{casenum}: #{result}"
      casenum += 1
      break
    end

    # advance the timestamp
    timestamp_top = next_timestamp + 1
    timestamp_bot = 1
  end
}
