# region_spec.rb - spec for method load_region

require_relative 'spec_helper'
require 'configuration'
require 'minitest/autorun'

# ENV['AWS_REGION'] 

describe 'load_region' do
  before { load_region }

  specify {ENV['AWS_REGION'].wont_be_nil }
  specify {ENV['AWS_REGION'].must_equal 'us-west-2'}
end
