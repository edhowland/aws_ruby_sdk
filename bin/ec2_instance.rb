#!/usr/bin/env ruby
# ec2_instance.rb - work with ec2 instance

require_relative '../lib/application'
require 'json'
require_relative 'ec2_options'
require_relative 'config_file'
require './messages'
require_relative 'format_fname'
require './requestor'
require './handle_instance_fake'
require './describe_image'

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
    keyname = name 
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

  def create_image name # {description: 'Create new AMI Image from this instance', arg: String, short: 'i'}
    print 'Name of image (3-128 chars)[Req.]: '; image_name= gets.chomp
    print 'Description of image [Opt.]: '; description = gets.chomp
    image_options = {
  #      dry_run: true,
        name: image_name
      }
    image_options[:description] = description unless description.length.zero?
    puts 'Using options:'
    p image_options
    puts "Attempting to create a new image in instance ID: #{name} with name: #{name} and description: #{description}"
    image = handle_instance @ec2, name, image_options do |instance, opts|
      instance.create_image opts
    end
    describe_image image unless image.nil?

  end

  def reboot_ec2 name # {description: 'Reboot EC2 Instance ID', arg: String, short: :nop}
    puts "Attempting to reboot instance ID: #{name}"
    response = handle_instance @ec2, name, {} do |instance, opts|
      instance.reboot opts
    end
  end

  def stop_ec2 name # {description: 'Stop EC2 Instance ID', short: 'p', arg: String}
    puts "Atteptemping to stop instance with id: #{name}"
    response = handle_instance @ec2, name do |instance, opts|
      instance.stop opts
    end


  end

  def start_ec2  name # { description: 'Starts a running EC2 Instance ID', arg: String}
    puts "Atteptemping to start instance with id: #{name}"
    response = handle_instance @ec2, name, { additional_info: "tarted by ec2_instance.rb"} do |instance, opts|
         instance.start opts
    end
  end

  def terminate_ec2 name # { description: 'Terminate EC2 Instance ID', arg: String}
    puts "Terminating instance ID: #{name}"
    response = handle_instance @ec2,name,  {} do |instance, opts|
      instance.terminate opts
    end
  end
end

class InstanceOptions < OptionDecorator
  def initialize options
    super
    @my_options = options
  end

  def delete_key name # {description: 'Delete Key Pair name', arg: String, short: :nop}
    @my_options[:delete_key] = name
  end

  def new_ec2 # {}
    @my_options[:new_ec2] = true
  end

  def create_image name # {description: 'Create new AMI Image from this instance', arg: String, short: 'i'}
    @my_options[:create_image] = name
  end

  def image_name name # {description: 'Set the name of the new image [Req.]', arg: String, short: 'N'}
  @my_options[:image_name] = name
  end

  def image_description name # {description: 'Set the description for the new image [Opt.]', short: 'D', arg: String}
    @my_options[:image_description] = name
  end

  def reboot_ec2 name # {description: 'Reboot EC2 Instance ID', arg: String, short: :nop}
    @my_options[:reboot_ec2] = name
  end

  def stop_ec2 name # {description: 'Stop EC2 Instance ID', short: 'p', arg: String}
  @my_options[:stop_ec2] = name
  end

  def start_ec2  name # { description: 'Starts a running EC2 Instance ID', arg: String}
    @my_options[:start_ec2] = name
  end

  def terminate_ec2 name # { description: 'Terminate EC2 Instance ID', arg: String}
    @my_options[:terminate_ec2] = name
  end
end


config_hash = {config_fname: 'default'}
config_file = ConfigFile.new config_hash

instance_hash = {}
instance_options = InstanceOptions.new instance_hash

options('EC2 Instance Operations') do |opts|
  config_file.set_options opts
  opts.separator ''
  instance_options.set_options opts
end

config_file.execute!

ec2_fname = format_fname(config_hash[:config_fname])
die("Missing EC2 Settings File: #{ec2_fname}") unless File.exists? ec2_fname
puts "Using settings in: #{ec2_fname}"
ec2_options = Ec2Options.load ec2_fname


instance_options.execute!
puts 'you set:'
p instance_hash


# execute requested actions
ec2 = ec2_resource
if id = instance_hash[:stop_ec2] 
  puts "Attempting to stop #{id}"
  handle_instance ec2, id do |instance, opts|
      instance.stop opts
  end
end

if id = instance_hash[:start_ec2]
    puts "Attempting to start instance with id: #{id}"
    response = handle_instance ec2, id, { additional_info: "tarted by ec2_instance.rb"} do |instance, opts|
         instance.start opts
    end
end

if id=instance_hash[:terminate_ec2]
  puts "Attempting to terminate EC2 ID #{id}"
  response = handle_instance ec2, id do |instance, opts|
    instance.terminate opts
  end
end

if id = instance_hash[:reboot_ec2]
    puts "Attempting to reboot instance ID: #{id}"
    response = handle_instance ec2, id, {} do |instance, opts|
      instance.reboot opts
    end
end

if instance_hash[:new_ec2]
  puts "Attempting to create new EC2 Instance with settings:"
  p ec2_options.options

    instances = ec2.create_instances @ec2_options.options
    puts "EC2 Instance ID: #{instances.first.id}"
end
exit
### remove this:
ec2_fname = format_fname 'default'
puts "Using options from #{ec2_fname}"
ec2_config = Ec2Options.load ec2_fname
requestor = Ec2Requestor.new ec2_config


options('EC2 Instance Operations') do |opts|
  requestor.set_options opts
end

check_and_execute requestor


