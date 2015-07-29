# expand_opt_spec.rb - specs for expand_opt

require_relative 'spec_helper'
require 'application'
require 'minitest/autorun'

#def expand_short key, options={}
#  (options[:short] == :nop ? nil : ('-' + (options[:short] || key.to_s[0]) + (options[:arg] ? ' name' : '')))
#end

class Cut < OptionDecorator
  def long_option # {description: 'Long Option'}
  end
end

describe 'expand_short' do
  let(:o) { Cut.new }
  let(:opt) { o.expand_short :option }
  let(:override) { o.expand_short :option, {short: 'p'} }
  let(:oarg) { o.expand_short :option, {arg: String} }
  let(:arg_over) { o.expand_short :option, {short: 'p', arg: String} }
  let(:noshort) { o.expand_short :option, {short: :nop} }
  let(:noshort_arg) { o.expand_short :option, {short: :nop, arg: String} }

  specify { opt.must_equal '-o' }
  specify { override.must_equal '-p' }
  specify { oarg.must_equal '-o name' }
  specify { arg_over.must_equal '-p name' }
  specify { noshort.must_be_nil }
  specify { noshort_arg.must_be_nil }
end
