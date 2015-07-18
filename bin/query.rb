#!/usr/bin/env ruby
# query.rb - Query AWS Resources

require '../lib/application'
require './messages'
require './requestor'

# All methods names matching option long names go here.
class QueryRequestor < RequestFramework
  def list_regions description='List U. S. Regions'
    return yield description if block_given? 

    puts description
  end
end

requestor = QueryRequestor.new

# set options from command line
options do |opts|
#  requestor.set_options opts
end

# check_and_execute requesto#r
