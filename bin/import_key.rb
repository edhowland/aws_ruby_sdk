#!/usr/bin/env ruby
# import_key.rb - import public key into AWS

require_relative '../lib/application'

class ImportRequestor < OptionDecorator
  def initialize ec2_options, options
    super
    @ec2_options = ec2_options
    @options = options
  end

  def dry_run #  { description: 'Dry run. Does not the public key, but checks parameters are ok', short: 'y' }

    @ec2_options[:dry_run] = true
  end

  def name name # { description: 'Name of the key pair', arg: String }
    @ec2_options[:key_name] = name
  end

  def file name # { description: 'Filename of the public key', arg: String }
    @options[:file] = name
  end

end
