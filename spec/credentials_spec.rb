# credentials_spec.rb - specs for credentials method

require_relative 'spec_helper'
require 'credentials'
require 'minitest/autorun'
#  ENV['AWS_ACCESS_KEY_ID']
#  ENV['AWS_SECRET_ACCESS_KEY'] 


describe 'load_credentials' do
  before { load_credentials }

  specify {ENV['AWS_ACCESS_KEY_ID'].wont_be_nil }
  specify { ENV['AWS_SECRET_ACCESS_KEY'].wont_be_nil } 
end
