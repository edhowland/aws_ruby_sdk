#!/usr/bin/env ruby
# ec2_instance.rb - work with ec2 instance

require_relative '../lib/application'
require './messages'
require './requestor'

class Ec2Requestor < OptionDecorator
  def create_key name # {description: 'Create Key Pair', arg: String }
    puts 'Creating Key Pair' + ' ' + name
  end

  def delete_key name # {description: 'Delete Key Pair', arg: String }
    puts "Deleting Key Pair : #{name}"
  end


end

requestor = Ec2Requestor.new


options('EC2 Instance Operations') do |opts|
  requestor.set_options opts
end

check_and_execute requestor


