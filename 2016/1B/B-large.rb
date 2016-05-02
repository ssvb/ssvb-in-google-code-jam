#!/usr/bin/env ruby

abort "Need input file name in the command line" if ARGV.size < 1

def maximize_pattern(pattern)
  pattern.map {|a| a == -1 ? 9 : a }
end

def minimize_pattern(pattern)
  pattern.map {|a| a == -1 ? 0 : a }
end

def pick_best_pair(a)
  bestidx  = -1
  bestdiff = 10 ** 20
  best_c   = 10 ** 20
  best_j   = 10 ** 20
  a.each.with_index do |a, idx|
    c = a[0].join.to_i
    j = a[1].join.to_i

    diff = c - j
    diff = -diff if diff < 0

    if (diff < bestdiff) ||
       (diff == bestdiff && c < best_c) ||
       (diff == bestdiff && c == best_c && j < best_j)
      bestdiff = diff
      bestidx = idx
      best_c = c
      best_j = j
    end
  end
  return a[bestidx]
end

def solve(patternc, patternj)
  return [], [] if patternc.size == 0

  candidates = []

  eq_c,  eq_j  = solve(patternc[1, 100], patternj[1, 100])
  min_c, max_j = minimize_pattern(patternc[1, 100]), maximize_pattern(patternj[1, 100])
  max_c, min_j = maximize_pattern(patternc[1, 100]), minimize_pattern(patternj[1, 100])

  if patternc[0] == -1 && patternj[0] == -1
    candidates.push([[0] + eq_c,  [0] + eq_j])
    candidates.push([[0] + max_c, [1] + min_j])
    candidates.push([[1] + min_c, [0] + max_j])
  elsif patternc[0] == -1
    j = patternj[0]
    candidates.push([[j] + eq_c,  [j] + eq_j])
    candidates.push([[j - 1] + max_c, [j] + min_j]) if j > 0
    candidates.push([[j + 1] + min_c, [j] + max_j]) if j < 9
  elsif patternj[0] == -1
    c = patternc[0]
    candidates.push([[c] + eq_c,  [c] + eq_j])
    candidates.push([[c] + min_c, [c - 1] + max_j]) if c > 0
    candidates.push([[c] + max_c, [c + 1] + min_j]) if c < 9
  elsif patternc[0] > patternj[0]
    candidates.push([[patternc[0]] + min_c, [patternj[0]] + max_j])
  elsif patternc[0] < patternj[0]
    candidates.push([[patternc[0]] + max_c, [patternj[0]] + min_j])
  else
    candidates.push([[patternc[0]] + eq_c, [patternj[0]] + eq_j])
  end

  res = pick_best_pair(candidates)
  return res[0], res[1]
end

input = File.read(ARGV[0]).split
t = input.shift.to_i
1.upto(t) do |casenum|
  c = input.shift.split(//).map {|a| (a == "?") ? -1 : a.to_i }
  j = input.shift.split(//).map {|a| (a == "?") ? -1 : a.to_i }

  results = solve(c, j).map {|a| a.join }.join(" ")

  puts "Case ##{casenum}: #{results}\n"
end
