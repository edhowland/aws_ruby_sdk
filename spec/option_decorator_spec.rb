# option_decorator_spec.rb - specs for option_decorator

require_relative 'spec_helper'
require 'application'
require 'minitest/mock'
require 'minitest/autorun'


# TODO: bug when no options exist in subclass
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

  describe 'options_args' do
    specify { opd.options_args.must_equal [[:list_things, '-l', '--list-things', 'List Things'] ] }

  end

class MyNoShort < OptionDecorator
  def no_something # {description: 'do nothing', short: nil}
  end
end
  describe 'args_to_opts_args' do
    let(:myo) { MyNoShort.new }
    before { @this = opd }
    describe 'simple' do
      subject { @this.args_to_opts_args @this.options_args }

      specify { subject.must_equal ['-l', '--list-things', 'List Things'] }
    end

    describe 'with missing short' do
      subject { m=myo; m.args_to_opts_args [[:no_something, nil, '--no-something-thing', 'do nothing']] }

      specify { subject.must_equal ['--no-something', 'do nothing'] }
    end
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

  describe 'expand_short' do
    subject { mcut.expand_short 'o', {} }

    specify { subject.must_equal '-o' }
  end

  describe 'expand_short with arg' do
    subject { mcut.expand_short 'k', {arg: String} }

    specify { subject.must_equal '-k name' }
  end
  describe 'expand_options' do
    before do
      @h = {
        create_key: {description: 'Create Key Pair', long: '--create-key name', short: '-k name', arg: String},
        delete_key: {description: 'Delete Key Pair', long: '--delete-key name', short: '-d name', arg: String}
      }
    end

    specify { mcut.options.must_equal @h }
  end


  describe 'options_args with values' do
    specify { mcut.options_args.must_equal [
      [:create_key, '-k name', '--create-key name', String, 'Create Key Pair'],
      [:delete_key, '-d name', '--delete-key name', String, 'Delete Key Pair']

    ] }
  end

end

$result = ''
class MixedCut < OptionDecorator
  def initialize
    super
  end

  def list_regions # {description: 'List U. S. Regions', short: 'r'}
    $result = 'us-west-1'
'us-west-1'
  end    

  def set_name name # {description: 'Set name', arg: String }
    name
  end
end


describe MixedCut do
    let(:mx) { MixedCut.new }

  describe 'set_options' do
    before do
      @mock = MiniTest::Mock.new
      @mock.expect(:on, nil, ['-r', '--list-regions', 'List U. S. Regions' ])
      @mock.expect(:on, nil, ['-s name', '--set-name name', String, 'Set name'  ])
    end

    it 'should set options via on() method' do
      mx.set_options @mock
      @mock.verify
    end
  end

class NoShort < OptionDecorator
  def no_something # {description: 'do nothing', short: nil}
  end
end

describe 'no short option' do
  let(:noshort) { NoShort.new }
  before { @mock = MiniTest::Mock.new; @mock.expect(:on, nil, ['--no-something', 'do nothing'])} 

  specify { skip();  noshort.set_options @mock; @mock.verify }
end




  describe 'exec_list' do
    before do
      ARGV.clear; ARGV << '-r'
      @mx = mx
      options {|opts| @mx.set_options opts }
    end

    specify { @mx.exec_list.must_equal [[:list_regions]] }
  end

  describe 'exec_list with 2 options and with arg' do
    before do
      ARGV.clear; ARGV << '--set-name'; ARGV << 'Mark'; ARGV << '-r'
      @mx = mx
      options {|opts| @mx.set_options opts }
  end

    specify { @mx.exec_list.must_equal [[:set_name, 'Mark'], [:list_regions]] }
  end

  describe 'execute' do
    specify { mx.execute([:list_regions]).must_equal 'us-west-1' }
    specify { mx.execute([:set_name, 'Mark']).must_equal 'Mark' }
  end

  describe 'execute!' do
    before do
      ARGV.clear; ARGV << '-r'
      @mx =mx
      options {|opts| @mx.set_options opts }
    end

    specify { @mx.execute!; $result.must_equal 'us-west-1' }
  end

  describe 'option_list' do
    specify { mx.option_list.must_equal "-r, --list-regions\tList U. S. Regions\n-s name, --set-name name\tSet name" }
  end
end
