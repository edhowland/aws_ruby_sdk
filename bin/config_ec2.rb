#!/usr/bin/env ruby
# config_ec2.rb - create ec2_XXX.json file

require 'json'
require_relative '../lib/application'
require_relative 'ec2_options'
require_relative 'messages'
require_relative 'requestor'

def format_fname name
  "ec2_#{name}.json"
end

class ConfigRequestor < OptionDecorator
  def initialize ec2_config
    super
    @ec2_config = ec2_config
  end
  def file name # {description: 'File name to create or read', arg: String}
  end

  def key_pair name # {description: 'Set Key Pair name', arg: String}
    @ec2_config.options[:key_name] = name
  end

  def type name # {description: 'Set Instance Type: E.g. t1.micro', arg: String}
    @ec2_config.options[:instance_type] = name
  end

  def image name # { description: 'Set AMI Image', arg: String }
    @ec2_config.options[:image_name] = name
  end

  def min_count count # { description: 'Set minimun count of instances', arg: Integer }
    @ec2_config.options[:min_count] = count
  end

  def display # {description: 'Display currently set EC2 options' }
    puts "Currently set options in #{@ec2_config.fname}"
    p @ec2_config.options
  end
end


ec2_options = Ec2Options.load format_fname('default')
requestor = ConfigRequestor.new ec2_options


options('Configure EC2 Instance Operations') do |opts|
  requestor.set_options opts
end

check_and_execute requestor

ec2_options.save


