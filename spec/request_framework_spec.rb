# request_framework_spec.rb -pec for RequestFramework

require_relative 'spec_helper'
require 'application'
require 'minitest/mock'
require 'minitest/autorun'

class Cut < RequestFramework
  def initialize
  end

  def list_things description='List Things', &blk
    return yield description if block_given?

    'list.things'
   end
  def other_thing description='Other Thing', &blk
    return yield description if block_given?

    'other.thing'
   end

  include EndHandlers
end

describe RequestFramework do
  let(:rqf) { Cut.new }

  describe 'calling handler methods' do
    specify { rqf.list_things.must_equal 'list.things' }
    specify { rqf.other_thing.must_equal 'other.thing' }
  end

  describe 'handlers' do
    specify { rqf.handlers.must_equal [:list_things, :other_thing] }
  end

  describe 'long_options' do
    before { @longs = {list_things: '--list-things', other_thing: '--other-thing' } }
    specify { rqf.long_options.must_equal @longs }
  end

  describe 'short_options' do
    before { @shorts = {list_things: '-l', other_thing: '-o'} }

    specify { rqf.short_options.must_equal @shorts }
  end

  describe 'descriptions' do
    before { @descriptions = {list_things: 'List Things', other_thing: 'Other Thing' } }
    specify { rqf.descriptions.must_equal @descriptions }
  end

  describe 'options_args' do
    specify { rqf.options_args.must_equal [[:list_things, '-l', '--list-things', 'List Things'], [:other_thing, '-o', '--other-thing', 'Other Thing']] }
  end

  describe 'set_options' do
    before do
      @mock = MiniTest::Mock.new
      @mock.expect(:on, nil, ['-l', '--list-things', 'List Things'])
      @mock.expect(:on, nil, ['-o', '--other-thing', 'Other Thing'])
    end

    subject { rqf.set_options @mock }

    specify { subject; @mock.verify }

  end
end
