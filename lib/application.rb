# application.rb - Loads all library files
require 'aws-sdk-resources'
require_relative 'support'
require_relative 'configuration'
require_relative 'configuration/region'
require_relative 'query'

# load regions and credentials
load_region
load_credentials
