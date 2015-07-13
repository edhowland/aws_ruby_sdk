# credentials_spec.rb - specs for credentials method

require_relative 'spec_helper'
require 'credentials'
require 'minitest/autorun'

describe 'load_credentials' do
  before { load_credentials }

  specify {ENV[].wont_be_nil }
end
