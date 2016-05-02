#########################################################
# Crystal compiler 0.15.0 from http://crystal-lang.org/ #
# (statically typed language, based on Ruby syntax)     #
#########################################################

abort "Need input file name in the command line" if ARGV.size < 1

def get_id(dict, word)
  if dict.has_key?(word)
    return dict[word]
  else
    newid = dict.size
    dict[word] = newid
    return newid
  end
end

def filter_out_badset(badset, data)
  data.map {|a| a.select {|a| !badset.has_key?(a) } }.select {|a| a.size > 0 }
end

def solve(data)
  return data.size if data.size <= 1

  # Remove single element arrays and duplicated multi-element arrays
  arr_freq = {} of Array(Int32)=>Int32
  data.each {|a| arr_freq[a] = (arr_freq[a]? || 0) + 1 }

  badset = {} of Int32=>Bool
  data.each do |a|
    if a.size <= arr_freq[a]
      a.each {|a| badset[a] = true }
    end
  end

  if badset.size > 0
    xdata = filter_out_badset(badset, data)
    return badset.size + solve(xdata)
  end

  # Remove arrays with unique elements
  freq = {} of Int32=>Int32
  data.each {|a| a.each {|a| freq[a] = (freq[a]? || 0) + 1 } }

  xdata = data.select do |a|
    isgood = true
    a.each {|a| isgood = false if freq[a] == 1 }
    isgood
  end

  if xdata.size < data.size
    return data.size - xdata.size + solve(xdata)
  end

  # Sort the array again after elements removal
  xdata = data.sort do |a, b|
    score_a = a.reduce(0) {|sum, a| sum += freq[a] }
    score_b = b.reduce(0) {|sum, a| sum += freq[a] }
    score_a <=> score_b
  end

  best = 0
  xdata[0].each do |a|
    ydata = filter_out_badset({a => true}, xdata[1, xdata.size])
    res = solve(ydata)
    best = res if res > best
  end
  return best + 1
end

input = File.read(ARGV[0]).split
t = input.shift.to_i
1.upto(t) do |casenum|
  n = input.shift.to_i

  data = [] of {Int32, Int32}
  dict1 = {} of String=>Int32
  dict2 = {} of String=>Int32
  n.times do
    a = get_id(dict1, input.shift)
    b = get_id(dict2, input.shift)
    data.push({a, b})
  end

  if dict2.size > dict1.size
    dict1, dict2 = dict2, dict1
    data.map! {|a| {a[1], a[0]} }
  end

  xxx = {} of Int32=>Array(Int32)
  data.each do |a|
    xxx[a[0]] = ([] of Int32) unless xxx.has_key?(a[0])
    xxx[a[0]].push(a[1])
  end

  yyy = xxx.to_a.map {|a| a[1].uniq.sort }.sort {|a, b| a.size <=> b.size }

  max_fakers = data.size - (dict1.size + dict2.size - solve(yyy))

  puts "Case ##{casenum}: #{max_fakers}\n"
end
