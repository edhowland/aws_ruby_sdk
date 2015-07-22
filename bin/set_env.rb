#!/usr/bin/env ruby
# set_env.rb - set environment to run aws clients
require_relative '../lib/application'

puts "AWS_REGION=#{ENV['AWS_REGION']} AWS_ACCESS_KEY_ID=#{ENV['AWS_ACCESS_KEY_ID']} AWS_SECRET_ACCESS_KEY=#{ENV['AWS_SECRET_ACCESS_KEY']}"
