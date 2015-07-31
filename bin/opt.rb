#!/usr/bin/env ruby
# opt.rb - ...
require 'optparse'

options={}
parser = OptionParser.new do |opts|

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
end


parser.parse!

puts 'options'
p options
