require 'spec_helper'

describe Spritely::Image do
  let(:path) { "#{__dir__}/../fixtures/test/foo.png" }
  let(:data) { File.read(path) }

  subject { Spritely::Image.new(data) }

  its(:data) { should eq(data) }

  describe '#top' do
    before { subject.top = 123 }

    its(:top) { should eq(123) }
  end

  describe '#left' do
    before { subject.left = 456 }

    its(:left) { should eq(456) }
  end
end
