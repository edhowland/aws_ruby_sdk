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
end
