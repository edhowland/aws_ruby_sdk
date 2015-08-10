#!/usr/bin/env ruby
# ec2_instance.rb - work with ec2 instance

require_relative '../lib/application'
require 'json'
require_relative 'json_store'
require_relative 'ec2_options'
require_relative 'instance_store'
require_relative 'config_file'
require_relative 'messages'
require_relative 'format_fname'
#require './requestor'
require_relative 'handle_ec2'
require_relative 'handle_instance'
require_relative 'describe_image'

# check key name s#yntax: must be form of: name.name
#def check_key_name_syntax keyname
#  raise RuntimeError.new("Key name: #{keyname} invalid/ Must be 'name.handle'") if keyname.split('.').length != 2
#end



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

  def image_name name # {description: 'Set the name of the new image [Req. if --create-image]', arg: String, short: 'N'}
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

    instances = handle_ec2 ec2 do |ec|
    ec.create_instances ec2_options.options
  end
  if instances.instance_of? Array
    instance_id =instances.first.id
      puts "EC2 Instance ID: #{instance_id}"
    if instance_name=config_hash[:instance_name]
      instance_fname = format_instance_fname instance_name
      instance_store = InstanceStore.new instance_fname, {instance_id: instance_id}    

      puts "Saving instance_data for #{instance_name} in #{instance_fname}"
      instance_store.save
    end
  else
    puts 'Error occured: No instances returned'
  end
end

if id = instance_hash[:create_image]
  die('Missing setting: image-name forcreate-image') unless instance_hash[:image_name]
  image_options =  { name: instance_hash[:image_name] }
    image_options[:description] = instance_hash[:image_description] unless instance_hash[:image_description].nil?
  puts "Attempting to create new image from EC2 ID: #{id}"
  p image_options

  image = handle_instance ec2, id, image_options do |instance, opts|
    instance.create_image opts
  end
  describe_image image unless image.nil?
end

if key_name= instance_hash[:delete_key]
    puts "Deleting Key Pair: #{key_name}"
 key_options = {key_names: [key_name]}
    key_pairs = ec2.key_pairs key_options
    key_pair = key_pairs.first
    raise RuntimeError.new("No key found matching: #{keyname}") if key_pair.nil?
    key_pair.delete
    puts "Key Pair #{keyname} deleted."
end
