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
  subject { cut.on_args({description: 'Long Option', short: '-l', long: '--long-option'}) }

  specify { subject.must_equal ['-l', '--long-option', 'Long Option'] } 
end

describe 'set_options'  do


end
