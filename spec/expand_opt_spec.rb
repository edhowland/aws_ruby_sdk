# expand_opt_spec.rb - specs for expand_opt

require_relative 'spec_helper'
require 'application'
require 'minitest/autorun'

def expand_short key, options={}
  '-' + (options[:short] || key.to_s[0])
end

describe 'expand_short' do
  let(:opt) { expand_short :option }
  let(:override) { expand_short :option, {short: 'p'} }

  specify { opt.must_equal '-o' }
  specify { override.must_equal '-p' }
end
