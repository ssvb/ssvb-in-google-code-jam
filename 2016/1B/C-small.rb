#!/usr/bin/env ruby

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

def get_stats(data)
  first = [0] * data.size
  second = [0] * data.size
  data.each do |a|
    first[a[0]] += 1
    second[a[1]] += 1
  end
  return first, second
end

def count_fakers(first, second, data)
  # Find the best suspect
  faker_idx = -1
  faker_first = -1
  faker_second = -1
  faker_score = data.size * 2 + 1
  data.each_with_index do |a, idx|
    score = first[a[0]] + second[a[1]]
    if first[a[0]] > 1 && second[a[1]] > 1 && score < faker_score
      faker_idx = idx
      faker_first = a[0]
      faker_second = a[1]
      faker_score = score
    end
  end

  # Return if there are no fakers
  return 0 if faker_idx < 0

  suspects_idx = [] #of Int32

  # Find other suspects
  data.each_with_index do |a, idx|
    if first[a[0]] > 1 && second[a[1]] > 1 && (faker_first == a[0] || faker_second == a[1])
      suspects_idx.push(idx)
    end
  end

  max_fakers = 0
  suspects_idx.each do |idx|
    xdata = data[0, idx] + data[idx + 1, data.size]
    first[data[idx][0]] -= 1
    second[data[idx][1]] -= 1
    fakers = count_fakers(first, second, xdata)
    first[data[idx][0]] += 1
    second[data[idx][1]] += 1

    max_fakers = fakers if fakers > max_fakers
  end
  return max_fakers + 1
end

input = File.read(ARGV[0]).split
t = input.shift.to_i
1.upto(t) do |casenum|
  n = input.shift.to_i

  data  = [] #of Array(Int32)
  dict1 = {} #of String=>Int32
  dict2 = {} #of String=>Int32
  n.times do
    a = get_id(dict1, input.shift)
    b = get_id(dict2, input.shift)
    data.push([a, b])
  end

  first, second = get_stats(data)
  max_fakers = count_fakers(first, second, data)

  puts "Case ##{casenum}: #{max_fakers}\n"
end
