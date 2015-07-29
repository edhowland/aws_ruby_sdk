# expand_opt_spec.rb - specs for expand_opt

require_relative 'spec_helper'
require 'application'
require 'minitest/autorun'

def expand_short key, options={}
  "-#{key.to_s[0]}"
end

describe 'expand_short' do
  let(:opt) { expand_short :option }

  specify { opt.must_equal '-o' }
end
