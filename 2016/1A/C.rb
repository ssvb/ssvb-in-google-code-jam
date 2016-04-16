#!/usr/bin/env ruby

abort "Need input file name in the command line" if ARGV.size < 1

BRUTEFORCE_VALIDATION = true

input = File.read(ARGV[0]).split

def check_loop_length(idx, bbf)
  initial_idx = idx
  visited = {}
  while true
    visited[idx] = true
    idx = bbf[idx]
    if visited.has_key?(idx)
      if idx == initial_idx
        return visited.size
      else
        return 0
      end
    end
  end
end

def check_chain_length(idx, bad_idx, rev_bbf)
  max_length = [idx]
  rev_bbf[idx].each do |next_idx|
    next if next_idx == bad_idx
    length = [idx] + check_chain_length(next_idx, bad_idx, rev_bbf)
    if length.size > max_length.size
      max_length = length
    end
  end
  return max_length
end

t = input.shift.to_i

1.upto(t) do |casenum|
  n = input.shift.to_i
  bbf = input.shift(n).map {|x| x.to_i - 1}

  rev_bbf = bbf.map {|x| []}
  bbf.each_with_index { |bbf, kid| rev_bbf[bbf].push(kid) }

  self_sufficient_chunks = 0
  results = []
  0.upto(n - 1) do |idx|
    count = check_loop_length(idx, bbf)
    results.push(count)
    if count == 2
      x1 = check_chain_length(idx, bbf[idx], rev_bbf)
      x2 = check_chain_length(bbf[idx], idx, rev_bbf)
      self_sufficient_chunks += x1.size + x2.size
    end
  end

  results.push(self_sufficient_chunks / 2)

  if BRUTEFORCE_VALIDATION && n < 9
    def is_valid_circle(data, sz, bbf)
      0.upto(sz - 1) do |idx|
        idx1 = data[(idx - 1) % sz]
        idx2 = data[(idx + 1) % sz]
        return false if bbf[data[idx]] != idx1 && bbf[data[idx]] != idx2
      end
      return true
    end
    circle_size = 0
    data = bbf.map.with_index {|a, idx| idx}
    data.permutation do |permutated_data|
      permutated_data.size.downto(2) do |sz|
        if is_valid_circle(permutated_data, sz, bbf)
          circle_size = sz if sz > circle_size
        end
      end
    end
    if circle_size != results.max
      abort "Bruteforce validation failed for the case ##{casenum}"
    end
  end

  puts "Case ##{casenum}: #{results.max}\n"
end
