# set_options_spec.rb - specs for set_options

require_relative 'spec_helper'
require 'application'
require 'minitest/mock'
require 'minitest/autorun'

class MixedCut < OptionDecorator
  def long_option # {description: 'Long Option' } 
  end
  def arg_option name # {description: 'Arg Option', arg: String}
  end

end

describe 'on_args' do
  let(:cut) { MixedCut.new }
  let(:noshort) { cut.on_args({description: 'No Short', short: nil, long: '--no-short'}) }
  let(:nolong) { cut.on_args({description: 'No Long', long: nil, short: '-n'}) }
  let(:arg) { cut.on_args({description: 'Arg', long: '--arg-option name', short: '-a name', arg: String}) }
  subject { cut.on_args({description: 'Long Option', short: '-l', long: '--long-option'}) }

  specify { subject.must_equal ['-l', '--long-option', 'Long Option'] } 
  specify { noshort.must_equal ['--no-short', 'No Short'] }
  specify { nolong.must_equal ['-n', 'No Long'] }
  specify { arg.must_equal ['-a name', '--arg-option name', String, 'Arg'] }
end

describe 'set_options'  do
  before do
    @mock = MiniTest::Mock.new
    @mock.expect(:on, nil, ['-l', '--long-option', 'Long Option'])
    @mock.expect(:on, nil, ['-a name', '--arg-option name', String, 'Arg Option'])
  end
  let(:cut) { MixedCut.new }
  subject { cut.set_options @mock }

  specify { subject; @mock.verify }
end
