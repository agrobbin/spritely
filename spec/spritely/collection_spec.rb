require 'spec_helper'

describe Spritely::Collection do
  let(:first_set) { double(repeated?: true, name: 'foo', width: 1, height: 10, images: [1]) }
  let(:second_set) { double(repeated?: false, name: 'bar', width: 100, height: 100, images: [2, 3]) }

  subject { Spritely::Collection.new(['file-1.png', 'file-2.png'], {'file-1' => {repeat: true}}) }

  before do
    allow(Spritely::ImageSet).to receive(:new).with('file-1.png', repeat: true).and_return(first_set)
    allow(Spritely::ImageSet).to receive(:new).with('file-2.png', nil).and_return(second_set)
  end

  its(:files) { should eq(['file-1.png', 'file-2.png']) }
  its(:options) { should eq({'file-1' => {repeat: true}}) }
  its(:images) { should eq([2, 3, 1]) }
  its(:height) { should eq(110) }

  describe '.create' do
    let(:collection) { double }

    it 'should attempt to generate the sprite' do
      allow(Spritely::Collection).to receive(:new).with('something').and_return(collection)
      expect(collection).to receive(:position!)
      Spritely::Collection.create('something')
    end
  end

  describe '#width' do
    let(:third_set) { double(repeated?: false, width: 65, height: 100) }

    subject { Spritely::Collection.new(['file-1.png', 'file-2.png', 'file-3.png'], {}) }

    before do
      allow(Spritely::ImageSet).to receive(:new).with('file-1.png', nil).and_return(first_set)
      allow(Spritely::ImageSet).to receive(:new).with('file-2.png', nil).and_return(second_set)
      allow(Spritely::ImageSet).to receive(:new).with('file-3.png', nil).and_return(third_set)
    end

    its(:width) { should eq(100) }

    context 'when the repetition will overflow the largest non-repeating image' do
      let(:first_set) { double(repeated?: true, width: 12, height: 10) }
      let(:second_set) { double(repeated?: false, width: 100, height: 100) }

      its(:width) { should eq(108) }
    end

    context 'when there are multiple repeating images, find the lcm' do
      let(:first_set) { double(repeated?: true, width: 12, height: 10) }
      let(:second_set) { double(repeated?: true, width: 100, height: 100) }
      let(:third_set) { double(repeated?: true, width: 65, height: 100) }

      its(:width) { should eq(3900) }
    end

    context 'when there is a mix of repeating and non-repeating' do
      let(:first_set) { double(repeated?: true, width: 12, height: 10) }
      let(:second_set) { double(repeated?: false, width: 100, height: 100) }
      let(:third_set) { double(repeated?: true, width: 5, height: 100) }

      its(:width) { should eq(120) }
    end
  end

  describe '#find' do
    it 'should find the correct set by name' do
      expect(subject.find('foo')).to eq(first_set)
      expect(subject.find('bar')).to eq(second_set)
    end
  end

  describe '#last_modification_time' do
    before do
      allow(Spritely).to receive(:modification_time).with('file-1.png').and_return(10)
      allow(Spritely).to receive(:modification_time).with('file-2.png').and_return(100)
    end

    its(:last_modification_time) { should eq(100) }
  end

  describe '#position!' do
    it 'should call out to each image set in turn' do
      expect(second_set).to receive(:top=).with(0)
      expect(second_set).to receive(:position_in!).with(100)
      expect(first_set).to receive(:top=).with(100)
      expect(first_set).to receive(:position_in!).with(100)
      subject.position!
    end
  end
end