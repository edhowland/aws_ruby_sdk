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

die "No such file: #{my_options[:file]}" unless File.exists? my_options[:file]

public_key = File.read my_options[:file]
#die 'Invalid public key format' unless parts.length == 3

#base64_data = parts[1]
ec2_options[:public_key_material] = public_key

begin
  ec2 = ec2_resource
  key_pair = ec2.import_key_pair ec2_options
rescue => err
    puts 'Import public key raised an error'
  puts err.message
end
p key_pair


