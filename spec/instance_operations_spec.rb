# instance_operations_spec.rb - specs for instance_operations

require_relative 'spec_helper'
require 'minitest/mock'

describe InstanceOperations do
  let(:mock) { MiniTest::Mock.new }

  describe 'stop' do
    before do
      @mock = mock
      @mock.expect(:stop, nil)
      @oper = InstanceOperations.new @mock
    end

    subject { @oper.stop }

    specify { subject; @mock.verify }
end
end
