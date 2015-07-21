#!/usr/bin/env ruby
# config_ec2.rb - create ec2_XXX.json file

require_relative '../lib/application'
require_relative 'messages'
require_relative 'requestor'

def formate_fname name
  "ec2_#{name}.json"
end

class ConfigRequestor < OptionDecorator

end

requestor = ConfigRequestor.new


options('Configure EC2 Instance Operations') do |opts|
  requestor.set_options opts
end

check_and_execute requestor


