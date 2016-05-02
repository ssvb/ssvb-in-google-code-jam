#!/usr/bin/env ruby

abort "Need input file name in the command line" if ARGV.size < 1

def compare(val, pattern)
  return false if val.size != pattern.size
  0.upto(val.size - 1) do |idx|
    return false if val[idx] != pattern[idx] && pattern[idx] != '?'
  end
  return true
end

def solve(patternc, patternj)
  bestdiff = 1000000
  best_c   = 1000000
  best_j   = 1000000

  0.upto(999) do |c|
    next if !compare(sprintf("%0#{patternc.size}d", c), patternc)
    0.upto(999) do |j|
      next if !compare(sprintf("%0#{patternj.size}d", j), patternj)

      diff = c - j
      diff = -diff if diff < 0

      if diff < bestdiff
        bestdiff = diff
        best_c = c
        best_j = j
      elsif diff == bestdiff && c < best_c
        bestdiff = diff
        best_c = c
        best_j = j
      elsif diff == bestdiff && c == best_c && j < best_j
        bestdiff = diff
        best_c = c
        best_j = j
      end 
    end
  end

  return sprintf("%0#{patternc.size}d", best_c), sprintf("%0#{patternj.size}d", best_j)
end

input = File.read(ARGV[0]).split
t = input.shift.to_i
1.upto(t) do |casenum|
  c = input.shift
  j = input.shift

  results = solve(c, j).join(" ")

  puts "Case ##{casenum}: #{results}\n"
end
