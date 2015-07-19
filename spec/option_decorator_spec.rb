# option_decorator_spec.rb - specs for option_decorator

require_relative 'spec_helper'
require 'application'
require 'minitest/autorun'


# code Under Test
# methods MUST be decorated with preceeding comment containing valid Ruby Hash
class Cut < OptionDecorator
  def list_things; end # { description: 'List Things' }
end


class MultiCut < OptionDecorator
  def create_key nme # {description: 'Create Key Pair', short: 'k', arg: String}
  end

  def delete_key name # {description: 'Delete Key Pair', arg: String}
  end
end

describe OptionDecorator do
  let(:opd) { Cut.new }
  describe 'method_list' do
    specify { opd.method_list[0].must_be_instance_of Method }
  end

  describe 'decorators' do
    before { @h = {list_things: {description: 'List Things'} } }
    specify { opd.decorators.must_equal @h }
  end
end


describe MultiCut do
  let(:mcut) { MultiCut.new }

  describe 'decorators' do
    before { @h = {
      create_key: {description: 'Create Key Pair', short: 'k', arg: String},
      delete_key: {description: 'Delete Key Pair', arg: String}
    } }

    specify { mcut.decorators.must_equal @h }
  end

  describe 'expand_options' do
    before do
      @h = {
        create_key: {description: 'Create Key Pair', long: '--create-key', short: '-k', arg: String},
        delete_key: {description: 'Delete Key Pair', long: '--delete-key', short: '-d', arg: String}
      }
    end

    specify { mcut.options.must_equal @h }
  end
end
