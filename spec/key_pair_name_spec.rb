# key_pair_name_spec.rb - specs for key_pair_name method

require_relative 'spec_helper'
require 'application'
require 'minitest/autorun'

describe 'key_pair_name' do
  let(:key_name) { key_pair_name 'edhowland',  'mnx-stuff' }

  specify { key_name.must_equal 'edhowland.mnx-stuff.us-east-1' }
end
