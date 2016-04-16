#!/usr/bin/env ruby

abort "Need input file name in the command line" if ARGV.size < 1

input = File.read(ARGV[0]).split.map {|x| x.to_i }

###############################################################################
# Returns an array with the information about the row/column candidate        #
# pairs based on inspecting data on the diagonal.                             #
###############################################################################

def analyze_data(lines_data)
  result = []
  orig_idx = (0 .. lines_data[0].size - 2).to_a
  data = lines_data.map do |a|
    x = []
    a.each {|y| x.push(y) }
    x
  end
  data.sort! {|a, b| a[0] <=> b[0] }

  while data.size > 1 && data[0][0] == data[1][0]
    result.push([data[0][-1], data[1][-1], orig_idx[0]])
    data.shift(2)
    data.each {|a| a.shift }
    orig_idx.shift
    data.sort! {|a, b| a[0] <=> b[0] }
  end

  data.sort! {|a, b| a[-2] <=> b[-2] }

  while data.size > 1 && data[-1][-2] == data[-2][-2]
    result.push([data[-2][-1], data[-1][-1], orig_idx[-1]])
    data.pop(2)
    data.each do |a|
      idx = a.pop
      a.pop
      a.push(idx)
    end
    orig_idx.pop
    data.sort! {|a, b| a[-2] <=> b[-2] }
  end

  result.push([data[0][-1], nil, orig_idx[0]])

  return result
end

###############################################################################

def test_grid(n, data, rows, columns)
  rows.each do |row, row_v|
    columns.each do |col, col_v|
      return false if data[row_v][col] != data[col_v][row]
    end
  end
  return true
end

def construct_grid(data, rows, columns, offs, candidates)
  n = data[0].size - 1
  return unless test_grid(n, data, rows, columns)

  if offs >= candidates.size
    grid = []
    bigger = (rows.size > columns.size) ? rows : columns
    bigger.each do |i, line_id|
      grid[i] = data[line_id].slice(0, n)
    end
    return grid
  end

  a = candidates[offs]


  res = construct_grid(data, rows.merge({a[2] => a[0]}),
                             columns.merge(a[1] ? {a[2] => a[1]} : {}),
                             offs + 1, candidates)
  return res if res

  res = construct_grid(data, rows.merge(a[1] ? {a[2] => a[1]} : {}),
                             columns.merge({a[2] => a[0]}),
                             offs + 1, candidates)
  return res if res
end

###############################################################################

t = input.shift

1.upto(t) do |casenum|
  n = input.shift.to_i
  data = []
  (2 * n - 1).times { data.push(input.shift(n)) }
  data.sort!
  orig_idx = (0 .. data[0].size - 1).to_a

  # Collect the probability statistics
  val_freq = {}
  data.each { |l| l.each { |v| val_freq[v] = (val_freq[v] || 0) + 1 }}
  data_score = {}
  data.each.with_index do |l, idx|
    score = 0
    l.each {|v| score += val_freq[v] }
    data_score[idx] =score
  end
  val_freq[nil] = 0

  have_lines = {}
  data.each {|a| have_lines[a.clone] = (have_lines[a.clone] || 0) + 1 }

  data.each.with_index {|a, idx| a.push(idx) }

  candidates = analyze_data(data)

  # Sort the row/column pairs, processing the ones with lowest
  # probability first (this improves performance)
  candidates.sort! { |a, b| [(data_score[a[0]] || 0), (data_score[a[1]] || 0)].min <=>
                            [(data_score[b[0]] || 0), (data_score[b[1]] || 0)].min }

  grid = construct_grid(data, {}, {}, 0, candidates)

  0.upto(n - 1) do |i|
    have_lines[grid[i]] = (have_lines[grid[i]] || 0) - 1
    tmp = []
    0.upto(n - 1) {|j| tmp.push(grid[j][i]) }
    have_lines[tmp] = (have_lines[tmp] || 0) - 1
  end

  result = nil
  have_lines.each {|k, v| result = k if v < 0 }
  puts "Case ##{casenum}: #{result.join(" ")}\n"
end
