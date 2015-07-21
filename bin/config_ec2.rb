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
    @ec2_options.options[:key_name] = name
  end
end


ec2_options = Ec2Options.load format_fname('default')
requestor = ConfigRequestor.new ec2_options


options('Configure EC2 Instance Operations') do |opts|
  requestor.set_options opts
end

check_and_execute requestor

ec2_options.save


