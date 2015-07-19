# option_decorator_spec.rb - specs for option_decorator

require_relative 'spec_helper'
require 'application'
require 'minitest/autorun'

class OptionDecorator < HandlerFramework
  def _end; end # need this to signal end of sublass method list

  def eval_source source_and_line 
    line = read_line *source_and_line
    method_and_comment = line.split('#')
      eval method_and_comment[1]
  end
  def method_list
    handlers.map {|h| self.method(h) }
  end

  def decorators
  #  method_list.map {|m| source = m.source_location; {m.name => read_line(source[0], source[1] )} }
    method_list.reduce({}) {|i,  m| i[m.name] = eval_source(m.source_location); i }
  end

  def decorators_hash
    decorators.map {|d| eval( d.split('#')[1]) }
  end

end

# code Under Test
# methods MUST be decorated with preceeding comment containing valid Ruby Hash
class Cut < OptionDecorator
  def list_things; end # { description: 'List Things' }
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
