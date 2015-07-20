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
end

requestor = QueryRequestor.new

# set options from command line
options do |opts|
  requestor.set_options opts
end

 check_and_execute requestor

