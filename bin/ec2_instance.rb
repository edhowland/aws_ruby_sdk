#!/usr/bin/env ruby
# ec2_instance.rb - work with ec2 instance

require_relative '../lib/application'

class Ec2Requestor < RequestFramework
  def create_key description='Create Key Pair'
    return yield description if block_given?
  end

  def delete_key description='Delete Key Pair'
    return yield description if block_given?
  end


  include EndHandlers
end

requestor = Ec2Requestor.new


options('EC2 Instance Operations') do |opts|
  requestor.set_options opts

end
