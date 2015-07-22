#!/usr/bin/env ruby
# import_key.rb - import public key into AWS

require_relative '../lib/application'
require_relative 'messages'
require_relative 'requestor'

class ImportRequestor < OptionDecorator
  def initialize ec2_options, options
    super
    @ec2_options = ec2_options
    @my_options = options
  end

  def dry_run # { description: 'Dry run. Does not the public key, but checks parameters are ok', short: 'y' }

    @ec2_options[:dry_run] = true
  end

  def name name # { description: 'Name of the key pair', arg: String }
    @ec2_options[:key_name] = name
  end

  def file name # { description: 'Filename of the public key', arg: String }
    @my_options[:file] = name
  end
end



# Main

ec2_options  = {}
my_options = {}

requestor = ImportRequestor.new ec2_options, my_options


options('Import Publick Key') do |opts|
  requestor.set_options opts
end

check_and_execute requestor

die 'Missing missing parameter: --name' unless ec2_options[:key_name]
die 'Missing parameter: --name' unless my_options[:file]


