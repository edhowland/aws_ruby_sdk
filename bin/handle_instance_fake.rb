# handle_instance_fake.rb - fake handle_instance

require 'minitest/mock'

def handle_instance ec2, name, opts={}, &blk
  puts "handle_instance: #{name}"
  nil
end
