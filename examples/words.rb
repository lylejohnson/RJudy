#
# The intent of this example is do some simple benchmarking of the
# JudySL array and Judy Hash versus Ruby's Hash. For this example
# we're obviously limited to string keys. It would also be good to
# examine more generally the Judy Hash versus Ruby's Hash.
#
# Good sources of word lists:
#
#	/usr/share/dict/words
#	find / -print > words.txt
#	http://www.dict.org
#	???
#

require 'benchmark'
require 'judy'

include Judy

def do_inserts(array, words)
  words.each do |word|
    array[word] = word
  end
end

def do_lookups(array, words)
  words.each do |word|
    array[word]
  end
end

File.open(ARGV[0] || '/usr/share/dict/words') do |file|
  # Read a bunch of words
  words = file.readlines
  words.each_with_index { |word, i| words[i] = word.chomp }
  
  judySLArray = JudySL.new
  judyHash = JudyHash.new
  rubyHash = {}
  
  puts "\n*** Insertion Times for #{words.length} words ***\n\n"
  
  Benchmark.bmbm do |job|
    job.report("nothing") do
      words.each {}
    end
    job.report("JudySL:") do
      do_inserts(judySLArray, words)
    end
    job.report("JudyHash:") do
      do_inserts(judyHash, words)
    end
    job.report("Hash:") do
      do_inserts(rubyHash, words)
    end
  end
  
  puts "\n*** Lookup Times for #{words.length} words ***\n\n"

  Benchmark.bmbm do |job|
    job.report("nothing") do
      words.each {}
    end
    job.report("JudySL:") do
      do_lookups(judySLArray, words)
    end
    job.report("JudyHash:") do
      do_lookups(judyHash, words)
    end
    job.report("Hash:") do
      do_lookups(rubyHash, words)
    end
  end
end
