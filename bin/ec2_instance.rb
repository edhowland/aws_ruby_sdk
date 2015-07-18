#!/usr/bin/env ruby
# ec2_instance.rb - work with ec2 instance

require_relative '../lib/application'
require './messages'

class Ec2Requestor < RequestFramework
  def create_key description='Create Key Pair'
    return yield description if block_given?

    puts 'Creating Key Pair'
  end

  def delete_key description='Delete Key Pair'
    return yield description if block_given?

    puts 'Deleting Key Pair'
  end


  include EndHandlers
end

requestor = Ec2Requestor.new


options('EC2 Instance Operations') do |opts|
  requestor.set_options opts
end


unless requestor.options_given?
  what_do_you_want_to_do requestor
  else
  # now call actually requested options
  requestor.execute!
end
