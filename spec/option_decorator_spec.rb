# option_decorator_spec.rb - specs for option_decorator

require_relative 'spec_helper'
require 'application'
require 'minitest/autorun'

class OptionDecorator < HandlerFramework
  def _end; end # need this to signal end of sublass method list

  def method_list
    handlers.map {|h| self.method(h) }
  end

  # returns lines preceding each method def
  def decorators
    method_list.map {|m| source = m.source_location; read_line(source[0], source[1] - 1) }
  end


end

# code Under Test
class Cut < OptionDecorator
  # description: 'List Things'
  def list_things; end
end

describe OptionDecorator do
  let(:opd) { Cut.new }
  describe 'method_list' do
    specify { opd.method_list[0].must_be_instance_of Method }
  end

  describe 'decorators' do
    specify { opd.decorators.must_equal ["  # description: 'List Things'"]  }
  end
end
