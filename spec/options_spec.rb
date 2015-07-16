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

describe 'option method' do
  let(:omock) { MiniTest::Mock.new }
  before do
    @mock = omock.expect(:on, nil, ['-r', '--reset', 'Reset things'])


    option @mock, :reset, 'Reset things'
  end

  it 'should set option' do
    @mock.verify
  end
end
