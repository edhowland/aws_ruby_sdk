# expand_opt_spec.rb - specs for expand_opt

require_relative 'spec_helper'
require 'application'
require 'minitest/autorun'

def expand_short key, options={}
  (options[:short] == :nop ? nil : ('-' + (options[:short] || key.to_s[0]) + (options[:arg] ? ' name' : '')))
end

describe 'expand_short' do
  let(:opt) { expand_short :option }
  let(:override) { expand_short :option, {short: 'p'} }
  let(:oarg) { expand_short :option, {arg: String} }
  let(:arg_over) { expand_short :option, {short: 'p', arg: String} }
  let(:noshort) { expand_short :option, {short: :nop} }
  let(:noshort_arg) { expand_short :option, {short: :nop, arg: String} }

  specify { opt.must_equal '-o' }
  specify { override.must_equal '-p' }
  specify { oarg.must_equal '-o name' }
  specify { arg_over.must_equal '-p name' }
  specify { noshort.must_be_nil }
  specify { noshort_arg.must_be_nil }
end
