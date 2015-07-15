# application.rb - Loads all library files
require 'aws-sdk-resources'
require_relative 'support'
require_relative 'configuration'
require_relative 'configuration/region'
require_relative 'query'
require_relative 'ec2'

# load regions and credentials
load_region
load_credentials
