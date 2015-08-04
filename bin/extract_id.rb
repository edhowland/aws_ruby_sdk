#!/usr/bin/env ruby
# extract_id.rb - extract id from output of -n

puts ARGF.read.split[3]
