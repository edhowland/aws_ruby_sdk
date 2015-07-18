#!/usr/bin/env ruby
# query.rb - Query AWS Resources

require '../lib/application'
require './messages'


# All methods names matching option long names go here.
class QueryRequestor < RequestFramework
  def list_regions description='List U. S. Regions'
    puts description
  end
end

requestor = QueryRequestor.new

# set options from command line
options do |opts|
  requestor opts
end
