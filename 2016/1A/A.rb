#!/usr/bin/env ruby

abort "Need input file name in the command line" if ARGV.size < 1

input = File.read(ARGV[0]).split

def gen_last_word(word)
  return word if word.size <= 1

  rev_word = word.reverse
  last_letter = word.sort.reverse[0]
  last_idx = word.size - rev_word.find_index(last_letter) - 1

  part1 = [last_letter]
  part2 = []
  part3 = []
  word.each_index do |idx|
    part2.push(word[idx]) if idx < last_idx
    part3.push(word[idx]) if idx > last_idx
  end

  return part1 + gen_last_word(part2) + part3
end

t = input.shift.to_i

1.upto(t) do |casenum|
  word = input.shift.split(//)
  puts "Case ##{casenum}: #{gen_last_word(word).join}"
end
