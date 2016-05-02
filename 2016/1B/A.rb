#!/usr/bin/env ruby

abort "Need input file name in the command line" if ARGV.size < 1

def remove_word(letterset, primary_letter, other_letters)
  other_letters = other_letters.split(//)
  count = letterset[primary_letter] || 0
  count.times do
    other_letters.each {|letter| letterset[letter] -= 1 }
  end
  return count
end

input = File.read(ARGV[0]).split
t = input.shift.to_i
1.upto(t) do |casenum|
  letterset = {}
  input.shift.split(//).each { |x| letterset[x] = (letterset[x] || 0) + 1 }

  results = {}

  results[0] = remove_word(letterset, "Z", "ZERO")
  results[2] = remove_word(letterset, "W", "TWO")
  results[6] = remove_word(letterset, "X", "SIX")
  results[7] = remove_word(letterset, "S", "SEVEN")
  results[4] = remove_word(letterset, "U", "FOUR")
  results[3] = remove_word(letterset, "R", "THREE")
  results[1] = remove_word(letterset, "O", "ONE")
  results[8] = remove_word(letterset, "T", "EIGHT")
  results[5] = remove_word(letterset, "F", "FIVE")
  results[9] = remove_word(letterset, "I", "NINE")

  results = results.to_a.select {|a| a[1] > 0 }.map {|a| a[0].to_s * a[1] }.sort.join("")

  puts "Case ##{casenum}: #{results}\n"
end
