# ec2_query.rb - Establish an EC2 Resource connection to AWS



require_relative 'spec_helper'
require 'application'
require 'minitest/autorun'

describe 'new EC2 Resource' do
  let(:ec2) { ec2_resource }

  specify { ec2.must_be_instance_of Aws::EC2::Resource }
end
