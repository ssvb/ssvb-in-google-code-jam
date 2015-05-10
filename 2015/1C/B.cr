########################################################
# Crystal compiler 0.6.1 from http://crystal-lang.org/ #
# (statically typed language, based on Ruby syntax)    #
########################################################

abort "Need input file name in the command line" if ARGV.size < 1

struct Float64
  def to_s
    String.new(64) do |buffer|
      LibC.sprintf(buffer, "%.18f", self)
      len = LibC.strlen(buffer)
      {len, len}
    end
  end
end

def word_probability(word, keyboard)
#  pp word
#  pp keyboard
  b_prob = [] of Float64
  256.times { b_prob.push(0.to_f64) }
  keyboard.each_byte { |b| b_prob[b] += 1.to_f64 }
  total = 1.to_f64
  word.each_byte { |b|
#    pp b_prob[b]
    total *= b_prob[b] / keyboard.size
#    pp total
  }
  total
end

def max_words(word, phraselen)
  1.upto(word.size - 1) { |offs|
    if word[0, word.size - offs] == word[offs, word.size - offs]
      return 1 + (phraselen - word.size) / offs
    end
  }
  phraselen / word.size
end

input = File.open(ARGV[0]).read.split

input.shift.to_i.times { |case_num|
  k, l, s = input.shift(3).map { |x| x.to_i }
  keyboard = input.shift
  word = input.shift
  p = word_probability(word, keyboard)
  result = 0.to_f64
#  pp p
  if p == 0 || word.size > s
    result = 0.to_f64
  else
    max_words = [max_words(word, s), max_words(word.reverse, s)].max
#    pp max_words
    avg = p * (s - word.size + 1)
    result = max_words.to_f64 - avg
  end
  STDOUT.puts "Case ##{case_num + 1}: #{result.to_s}"
}
