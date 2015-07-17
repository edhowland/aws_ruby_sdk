# request_framework_spec.rb -pec for RequestFramework

require_relative 'spec_helper'
require 'application'
require 'minitest/autorun'

class Cut < RequestFramework
  def list_things description='List Things', &blk
    return yield description if block_given?
   end
  def other_thing description='Other Thing', &blk
    return yield description if block_given?
   end

  include EndHandlers
end

describe RequestFramework do
  let(:rqf) { Cut.new }

  describe 'handlers' do
    specify { rqf.handlers.must_equal [:list_things, :other_thing] }
  end

  describe 'long_options' do
    specify { rqf.long_options.must_equal ['--list-things', '--other-thing'] }
  end

  describe 'short_options' do
    before { @shorts = {list_things: '-l', other_thing: '-o'} }

    specify { rqf.short_options.must_equal @shorts }
  end

  describe 'descriptions' do
    before { @descriptions = {list_things: 'List Things', other_thing: 'Other Thing' } }
    specify { rqf.descriptions.must_equal @descriptions }
  end
end
