#!/usr/bin/env ruby
# ec2_instance.rb - work with ec2 instance

require 'pry'
require_relative '../lib/application'
require './messages'
require './requestor'

# check key name syntax: must be form of: name.name
def check_key_name_syntax keyname
  raise RuntimeError.new("Key name: #{keyname} invalid/ Must be 'name.handle'") if keyname.split('.').length != 2
end

class Ec2Requestor < OptionDecorator
  def initialize
    super
    @ec2 = ec2_resource
    @ec2_options = {} # {dry_run: true} # TODO: must be: = {}
  end

  def create_key name # {description: 'Create Key Pair', arg: String }
    check_key_name_syntax name
    keyname = key_name name
    puts "Creating Key Pair: #{keyname}"
    @ec2_options[:key_name] = keyname
    key_pair = @ec2.create_key_pair @ec2_options
#pry

    keyfname = keyname + '_rsa'
  File.write(keyfname, '(Smack Stuff)')
    puts "Wrote private key to: #{keyfname}"
  end

  def delete_key name # {description: 'Delete Key Pair', arg: String }
    check_key_name_syntax name
  
    keyname = key_name name
    puts "Deleting Key Pair : #{keyname}"
    @ec2_options[:key_name] = keyname
    @ec2.delete_key_pair @ec2_options
  end


end

requestor = Ec2Requestor.new


options('EC2 Instance Operations') do |opts|
  requestor.set_options opts
end

check_and_execute requestor


