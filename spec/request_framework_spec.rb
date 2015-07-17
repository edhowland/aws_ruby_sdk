# request_framework_spec.rb -pec for RequestFramework

require_relative 'spec_helper'
require 'application'
require 'minitest/autorun'

class Cut < RequestFramework
  def list_things
   end
  def other_thing
   end

  include EndHandlers
end

describe RequestFramework do
  let(:rqf) { Cut.new }

  describe 'handlers' do
    specify { rqf.handlers.must_equal [:list_things, :other_thing] }
  end

  describe 'option_list' do
    specify { rqf.option_list.must_equal ['list-things', 'other-thing'] }
  end

end
