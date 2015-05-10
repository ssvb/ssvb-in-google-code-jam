########################################################
# Crystal compiler 0.6.1 from http://crystal-lang.org/ #
# (statically typed language, based on Ruby syntax)    #
########################################################

abort "Need input file name in the command line" if ARGV.size < 1

input = File.open(ARGV[0]).read.split.map { |x| x.to_i }

input.shift.times { |case_num|
  height, width, shipsize = input.shift(3)
  result = 0
  if height > 1
    result += (height - 1) * (width / shipsize)
    height = 1
  end
  if width == shipsize
    result += shipsize
  else
    result += (width - 1) / shipsize
    result += shipsize
  end
  STDOUT.puts "Case ##{case_num + 1}: #{result}"
}
