# set_options_spec.rb - specs for set_options

require_relative 'spec_helper'
require 'application'
require 'minitest/autorun'

class MixedCut < OptionDecorator
  def long_option # {description: 'Long Option' } 
  end

end

describe 'on_args' do
  let(:cut) { MixedCut.new }
  let(:noshort) { cut.on_args({description: 'No Short', short: nil, long: '--no-short'}) }
  let(:nolong) { cut.on_args({description: 'No Long', long: nil, short: '-n'}) }
  subject { cut.on_args({description: 'Long Option', short: '-l', long: '--long-option'}) }

  specify { subject.must_equal ['-l', '--long-option', 'Long Option'] } 
  specify { noshort.must_equal ['--no-short', 'No Short'] }
  specify { nolong.must_equal ['-n', 'No Long'] }
end

describe 'set_options'  do


end
