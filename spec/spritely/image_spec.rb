require 'spec_helper'

describe Spritely::Image do
  let(:path) { "#{__dir__}/../fixtures/test/foo.png" }

  subject { Spritely::Image.new(path) }

  its(:path) { should eq(path) }
  its(:data) { should eq(File.read(path)) }
  its(:width) { should eq(1) }
  its(:height) { should eq(1) }
  its(:left) { should eq(0) }
  its(:name) { should eq('foo') }

  describe '#top' do
    before { subject.top = 123 }

    its(:top) { should eq(123) }
  end
end
