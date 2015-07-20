#!/usr/bin/env ruby
# ec2_instance.rb - work with ec2 instance

require_relative '../lib/application'
require './messages'
require './requestor'

class Ec2Requestor < OptionDecorator
  def initialize
    super
    @ec2 = ec2_resource
  end

  def create_key name # {description: 'Create Key Pair', arg: String }
    keyname = key_name name
    puts "Creating Key Pair: #{keyname}"
    key_pair = @ec2.key_pairs.create keyname

    keyfname = keyname + '_rsa'
  File.write(keyfname, '(Smack Stuff)')
    puts "Wrote private key to: #{keyfname}"
  end

  def delete_key name # {description: 'Delete Key Pair', arg: String }
    puts "Deleting Key Pair : #{name}"
  end


end

requestor = Ec2Requestor.new


options('EC2 Instance Operations') do |opts|
  requestor.set_options opts
end

check_and_execute requestor


