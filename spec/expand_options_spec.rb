# expand_options_spec.rb - specs for expand_options

require_relative 'spec_helper'
require 'application'
require 'minitest/autorun'


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

describe 'expand_long' do
  let(:o) { Cut.new }
  let(:long) { o.expand_long :long_option }
  let(:over) { o.expand_long :long_option, {long: 'other-option'} }
  let(:nop) { o.expand_long :long_option, {long: :nop} }
  let(:arg) { o.expand_long :long_option, {arg: String} }

  specify { long.must_equal '--long-option' }
  specify { over.must_equal '--other-option' }
  specify { nop.must_be_nil }
  specify { arg.must_equal '--long-option name' }
end

describe 'expand_options' do
let(:cut) { Cut.new }
let(:opt) { 
{long_option: {short: '-l', long: '--long-option', description: 'Long Option'} }
}

  subject { cut.expand_options }

  specify { subject.must_equal opt }
end


class MixedCut < OptionDecorator
  def long_option # { description: ' Long Option' }
  end

  def short_option # { description: 'Short Option', short: 'o', long: :nop }
  end
  def arg_option name # { description: 'Arg Option',arg: String }
  end
  def no_short # { description: 'No Short', short: :nop}
  end 
end

describe 'expand_options: Mixed' do
  let(:cut) { MixedCut.new }
  subject { cut.expand_options }

  # now check all individual option settings
  specify { subject[:long_option][:short].wont_be_nil }
  specify { subject[:no_short][:short].must_be_nil }
  specify { subject[:arg_option][:short].must_equal '-a name' }

end
