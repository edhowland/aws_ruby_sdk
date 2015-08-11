# instance_operations_spec.rb - specs for instance_operations

require_relative 'spec_helper'
require 'minitest/mock'

describe InstanceOperations do
  let(:mock) { MiniTest::Mock.new }

  describe 'stop' do
    before do
      @mock = mock
      @mock.expect(:stop, nil, [{}])
      @oper = InstanceOperations.new @mock
    end

    subject { @oper.stop }

    specify { subject; @mock.verify }
end

  describe 'start' do
    let(:starter) { m=mock; m.expect(:start, nil, [{}]); m }
    before { @mock=starter }
    subject { oper=InstanceOperations.new @mock; oper.start }

    specify { subject; @mock.verify }
  end

  describe 'reboot' do
    let(:rebooter) { m=mock; m.expect(:reboot, nil, [{}]); m }
    before { @mock = rebooter }
    subject { oper=InstanceOperations.new @mock; oper.reboot }

    specify { subject; @mock.verify }
  end

  describe 'describe' do
    class InstanceAttrFake
  def initialize
    @called = false
  end

  attr_reader :called

  def method_missing *args
    @called = true
  end
  end

  
 before { @fake=InstanceAttrFake.new; @io=InstanceOperations.new(@fake) }
    subject { @io.describe }

    specify { subject.must_be_instance_of Hash }
  specify { subject; @fake.called.must_equal true }
  end

  class InstanceFake
  def stop options
      raise RuntimeError.new 'bad juju'
  end
  end

  describe 'stop raising exception' do
    let(:oper) { InstanceOperations.new InstanceFake.new }
    subject { oper.stop }

    specify { subject }
  end

  describe 'terminate' do

  let(:term) { m=mock; m.expect(:terminate, nil, [{}]); m }
    before { @mock=term }
    subject { oper=InstanceOperations.new @mock; oper.terminate }

    specify { subject; @mock.verify }
  end
end
