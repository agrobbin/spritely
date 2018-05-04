require 'spec_helper'
require 'ostruct'

describe Spritely::ImageSet do
  let(:path) { "#{__dir__}/../fixtures/test/foo.png" }
  let(:options) { {repeat: 'true', spacing_before: '5', spacing_after: '10', opposite: 'true'} }

  subject { Spritely::ImageSet.new(path, options) }

  its(:path) { should eq(path) }
  its(:options) { should eq(options) }
  its(:data) { should eq(File.read(path)) }
  its(:size) { should eq(68) }
  its(:width) { should eq(1) }
  its(:height) { should eq(2) }
  its(:name) { should eq('foo') }
  its(:top) { should eq(0) }
  its(:left) { should eq(0) }
  its(:spacing_before) { should eq(5) }
  its(:spacing_after) { should eq(10) }

  describe '#top' do
    before { subject.top = 123 }

    its(:top) { should eq(123) }
  end

  describe '#left' do
    before { subject.left = 123 }

    its(:left) { should eq(123) }
  end

  describe '#outer_size' do
    it 'adds the spacing to the dimension' do
      expect(subject.outer_size(:width)).to eq(16)
      expect(subject.outer_size(:height)).to eq(17)
    end
  end

  describe '#repeated?' do
    it { should be_repeated }

    context 'repeat option is passed as false' do
      let(:options) { {repeat: false} }

      it { should_not be_repeated }
    end

    context 'repeat option is not passed' do
      let(:options) { {} }

      it { should_not be_repeated }
    end
  end

  describe '#opposite?' do
    it { should be_opposite }

    context 'position option is passed as false' do
      let(:options) { { position: 'false' } }

      it { should_not be_opposite }
    end

    context 'position option is not passed' do
      let(:options) { {} }

      it { should_not be_opposite }
    end
  end

  describe '#add_image!' do
    # images << Image.new(data).tap do |image|
    #   image.top = top + top_offset
    #   image.left = left + left_offset
    # end
    before do
      subject.top = 5
      subject.left = 10
    end

    it 'adds a new image to the set' do
      expect(subject.images).to eq([])

      subject.add_image!(10, 15)

      expect(subject.images.length).to eq(1)
      expect(subject.images.first.top).to eq(15)
      expect(subject.images.first.left).to eq(25)
    end
  end
end
