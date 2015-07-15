# options_spec.rb - specs for method options

require_relative 'spec_helper'
require 'application'
require 'minitest/mock'
require 'minitest/autorun'

def stub_region(region)
  ARGV << '-r'
  ARGV << region
end

describe 'options' do
  before { stub_region('us-west-2') }

  specify { ARGV[0].must_equal '-r' }
end
