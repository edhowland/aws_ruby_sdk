# options_spec.rb - specs for method options

require_relative 'spec_helper'
require 'application'
require 'minitest/mock'
require 'minitest/autorun'

def stub_region(region)
  ARGV << '--region'
  ARGV << region
end

describe 'options' do
  before { stub_region('us-west-2'); options }

  specify { ENV['AWS_REGION'].must_equal 'us-west-2'}
end
