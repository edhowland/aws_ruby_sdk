# s3_spec.rb - specs for s3_query

require_relative 'spec_helper'
require 'application'
require 'minitest/autorun'

describe 's3_resource' do
  let(:s3) { s3_resource }

  specify { s3.must_be_instance_of Aws::S3::Resource }
end
