#!/usr/bin/env ruby
# query.rb - Query AWS Resources

require_relative  '../lib/application'
require './messages'
require './requestor'

# All methods names matching option long names go here.
class QueryRequestor < OptionDecorator
  def list_regions # {description: 'List U. S. Regions', short: 'r'}
    puts <<-EOP
us-east-1
us-west-1
us-west-2
EOP
  end


  def list_keys # {description: 'List Key Pairs', short: 'k'}

  end

  def list_vpcs # {description: 'List Virtual Private Clouds', short: 'v'}
  end

  def list_groups # {description: 'List Security Groups', short: 'g'}
  end

  def list_ec2 # {description: 'List EC2 Instances', short: 'e'}
  end

  def list_s3 # {description: 'List S3 Objects', short: 's'}
  end
end

requestor = QueryRequestor.new

# set options from command line
options do |opts|
  requestor.set_options opts
end

 check_and_execute requestor

