# expand_opt_spec.rb - specs for expand_opt

require_relative 'spec_helper'
require 'application'
require 'minitest/autorun'

def expand_short key, options={}
  '-' + (options[:short] || key.to_s[0]) + (options[:arg] ? ' name' : '')
end

describe 'expand_short' do
  let(:opt) { expand_short :option }
  let(:override) { expand_short :option, {short: 'p'} }
  let(:oarg) { expand_short :option, {arg: String} }

  specify { opt.must_equal '-o' }
  specify { override.must_equal '-p' }
  specify { oarg.must_equal '-o name' }
end
