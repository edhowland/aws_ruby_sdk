#!/usr/bin/env ruby
# config_ec2.rb - create ec2_XXX.json file

require 'json'
require_relative '../lib/application'
require_relative 'format_fname'
require_relative 'ec2_options'
require_relative 'messages'
require_relative 'requestor'


class ConfigRequestor < OptionDecorator
  def initialize ec2_config
    super
    @ec2_config = ec2_config
  end

  def init_defaults # { description: 'Initialize default settings', short: :nop}
    puts 'Initialize defaults'
  @ec2_config = Ec2Options.default
    puts 'Currently defaults:'
    p @ec2_config.options
    puts "Saving defaults to #{@ec2_config.fname}"
    @ec2_config.save
  end

  def dry_run # {description: 'Set dry_run parameter', short: 'y' }
    @ec2_config.options[:dry_run] = true
  end

  def no_dryrun # { description: 'Unset dry_run parameter' }
    @ec2_config.options.delete :dry_run
  end

  def key_pair name # {description: 'Set Key Pair name', arg: String}
    @ec2_config.options[:key_name] = name
  end

  def type name # {description: 'Set Instance Type: E.g. t1.micro', arg: String}
    @ec2_config.options[:instance_type] = name
  end

  def image name # { description: 'Set AMI Image ID', arg: String }
    @ec2_config.options[:image_id] = name
  end

  def min_count count # { description: 'Set minimun count of instances', arg: Integer }
    @ec2_config.options[:min_count] = count
  end

  def max_count count # { description: 'Set maximum instance count', short: 'x', arg: Integer }
    @ec2_config.options[:max_count] = count
  end

  def security_groups name # { description: 'Set security group', short: 'g', arg: String}
    @ec2_config.options[:security_groups] = [name]
  end
  def no_securitygroup # {description: 'Unset security Group', short: :nop}
    @ec2_config.options.delete :security_groups

  end

  def display # {description: 'Display currently set EC2 options' }
    puts "Currently set options "
    p @ec2_config.options
  end
end


ec2_fname = format_fname 'default'
puts "Currently operating on #{ec2_fname}"
File.write(ec2_fname, {}.to_json)unless File.exists? ec2_fname


ec2_options = Ec2Options.load ec2_fname
requestor = ConfigRequestor.new ec2_options


options('Configure EC2 Instance Operations') do |opts|
  requestor.set_options opts
end

check_and_execute requestor

ec2_options.save


