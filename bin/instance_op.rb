#!/usr/bin/env ruby
# instance_op.rb - perform operation on EC2 instance

require 'json'
require_relative '../lib/application'
require_relative 'config_file'
require_relative 'format_fname'

class InstanceFlags < OptionDecorator
  def initialize options
    super
    @my_options = options
  end

  def stop # {description: 'Stop EC2 instance', short: 'p'}
    @my_options[:stop] = true
  end

  def start # {description: 'Start Instance'}
    @my_options[:start] = true
  end

  def reboot # {description: 'Reboot running instance', short: :nop}
    @my_options[:reboot] = true
  end

  def describe # {description: 'Describe the instance' }
    @my_options[:describe] = true
  end

  def json # {description: 'Description output in JSON' }
    @my_options[:json] = true
  end

  def save # {description: 'Save state and ip addresses in named JSON', short: :nop}
    @my_options[:save] = true
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

instance_id = nil
if iname=config_hash[:instance_name]
  ifname = format_instance_fname iname
die("No Instance JSON for #{iname} in #{ifname}") unless File.exists? ifname
  instance_store = InstanceStore.load ifname
  instance_id = instance_store.options[:instance_id]
  puts "Using instance id: #{instance_id}"
else
  die 'No instance name given. Use -N, --instance-name option'
end

instance_flags.execute!
die('No operation given. Use -h, --help for a list of operations') if instance_hash.empty?

def handle_instance ec2, id, &blk
  response = nil
  begin
    instance = ec2.instance id
    instance_operations = InstanceOperations.new instance
    response = yield instance_operations
  rescue => err
    puts err.message
  end

  response
end


ec2 = ec2_resource

if instance_hash[:stop]
  handle_instance ec2, instance_id do |instance|
    instance.stop
    puts "Instance #{instance_id} stop operation started"
    puts "When done, you can describe it with : ./instance_op.rb -N #{iname} --describe"
  end
end

if instance_hash[:start]
  handle_instance ec2, instance_id do |instance|
    instance.start
    puts "Instance #{instance_id} start operation started"
    puts "When done, you can describe it with : ./instance_op -N #{iname} --describe"
  end
end

if instance_hash[:describe]
  handle_instance ec2, instance_id do |instance|
    describe_hash = instance.describe
    (instance_hash[:json] and (p describe_hash.to_json)) or
      p describe_hash
  end
end

if instance_hash[:save]
  istore = InstanceStore.new ifname
  handle_instance ec2, instance_id do |instance|
    istore.options = instance.describe
    istore.save
    puts "Current state of #{instance_id} stored in #{ifname}"
  end
end
