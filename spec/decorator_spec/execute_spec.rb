# execute_spec.rb - specs for execute

require_relative 'spec_helper'
require 'application'
require 'minitest/autorun'

class ExeCut < OptionDecorator
  def long_option # {description: 'Long Option' }
  end
  def arg_option name # {description: 'Arg Option', arg: String}
  end
end

describe 'exec_object' do
  let(:cut) { ExeCut.new }
  let(:long) { cut.exec_object :long_option, {}, nil }
  subject { cut.exec_object :arg_option, {arg: String}, 'string' }
  specify { subject.must_equal [:arg_option, 'string'] }
  specify { long.must_equal [:long_option] }
end
