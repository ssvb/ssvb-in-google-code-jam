#!/usr/bin/env ruby

abort "Need input file name in the command line" if ARGV.size < 1

input = File.open(ARGV[0]).read.split.map {|x| x.to_i }

casenum = 1
t = input.shift

1.upto(t) {
  n = input.shift
  msr = input.shift(n)
  count = 0
  eat_rate = 0
  1.upto(n - 1) {|idx|
    eaten = [msr[idx - 1] - msr[idx], 0].max
    eat_rate = [eaten, eat_rate].max
    count += eaten
  }

  # take care of the pauses
  pause_count = 0
  1.upto(n - 1) {|idx|
    if msr[idx - 1] < eat_rate
      pause_count += eat_rate - msr[idx - 1]
    end
  }

  puts "Case ##{casenum}: #{count} #{eat_rate * (n - 1) - pause_count}"
  casenum += 1
}
