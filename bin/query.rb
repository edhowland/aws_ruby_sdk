#!/usr/bin/env ruby
# query.rb - query AWS resources

require '../lib/application'

puts "Aquireing EC2 rsource in Region: #{ENV['AWS_REGION']}"
ec2 = ec2_resource

puts 'Enumerating EC2 Instances'
puts 'This could take some few minutes.'
instances = ec2.instances
instance_count = 0
instances.each do |instance|
  puts 'Instance of EC2'
  instance_count += 1
end

puts "Found #{instance_count} Instances"


puts 'Done'
