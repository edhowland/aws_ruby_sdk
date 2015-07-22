#!/usr/bin/env ruby
# import_key.rb - import public key into AWS

require_relative '../lib/application'

class ImportRequestor < OptionDecorator
  def name # { description: 'Name of the key pair' }

  end

  def file # { description: 'Filename of the public key' }
  end

end
