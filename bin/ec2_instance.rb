#!/usr/bin/env ruby
# ec2_instance.rb - work with ec2 instance

require_relative '../lib/application'
require 'json'
require_relative 'ec2_options'
require './messages'
require './requestor'

# check key name syntax: must be form of: name.name
def check_key_name_syntax keyname
  raise RuntimeError.new("Key name: #{keyname} invalid/ Must be 'name.handle'") if keyname.split('.').length != 2
end

class Ec2Requestor < OptionDecorator
  def initialize ec2_config
    super
    @ec2 = ec2_resource
    @ec2_options = {} # {dry_run: true} # TODO: must be: = {}
    @ec2_config = ec2_config
  end

  def create_key name # {description: 'Create Key Pair', arg: String }
    check_key_name_syntax name
    keyname = key_name name
    puts "Creating Key Pair: #{keyname}"
    @ec2_options[:key_name] = keyname
    key_pair = @ec2.create_key_pair @ec2_options
    puts "Key Pair created. Fingerprint: #{key_pair.key_fingerprint}"
  end

  def delete_key name # {description: 'Delete Key Pair', arg: String }
    #check_key_name_syntax name
  
    keyname = key_name name
    puts "Deleting Key Pair : #{keyname}"
    @ec2_options[:key_names] = [keyname]
    key_pairs = @ec2.key_pairs @ec2_options
    key_pair = key_pairs.first
    raise RuntimeError.new("No key found matching: #{keyname}") if key_pair.nil?
    key_pair.delete
    puts "Key Pair #{keyname} deleted."
  end

  def new_ec2 # { description: 'Create a new EC2 Instance', }
    puts 'Using options:'
    p @ec2_config.options

    instances = @ec2.create_instances @ec2_config.options
    puts "EC2 Instance ID: #{instances.first.id}"

  end
end

ec2_config = Ec2Options.load 'ec2_default.json'
requestor = Ec2Requestor.new ec2_config


options('EC2 Instance Operations') do |opts|
  requestor.set_options opts
end

check_and_execute requestor


