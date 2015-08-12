# storage_spec.rb - specs for storage

require_relative 'spec_helper'

describe JsonStore do
  describe 'merge!' do
    let(:h_start) { {description: 'name'} }
    let(:h_2) { {instance_id: 'i-xxxx'} }
    let(:stor) { JsonStore.new '', h_start }
    let(:expected) { {description: 'name', instance_id: 'i-xxxx'} }
    let(:stor2) { JsonStore.new '', h_2 }

    subject { stor.merge!(stor2) }


    specify { subject.must_equal expected }
  end
end
