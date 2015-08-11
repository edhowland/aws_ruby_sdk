#!/usr/bin/env ruby
# ec2_operation.rb - perform operation on EC2 instance

require 'json'
require_relative '../lib/application'
require_relative 'config_file'

class InstanceFlags < OptionDecorator
  def initialize options
    super
    @my_options = options
  end

  def stop # {description: 'Stop EC2 instance', short: 'p'}
    @my_options[:stop] = true
  end
end

config_hash = {}
config_file = ConfigFile.new config_hash

instance_hash = {}
instance_flags = InstanceFlags.new instance_hash

options('EC2 Operation') do |opts|
  config_file.set_options opts
  opts.separator ''
  instance_flags.set_options opts
end

config_file.execute!

if iname=config_hash[:instance_name]

else
  die 'No instance name given. Use -N, --instance-name option'
end
