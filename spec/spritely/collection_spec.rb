require 'spec_helper'

describe Spritely::Collection do
  let(:first_set) { double(name: 'foo', images: [1]) }
  let(:second_set) { double(name: 'bar', images: [2, 3]) }
  let(:sort_options) { ['name'] }
  let(:layout) { double(width: 100, height: 110) }

  subject { Spritely::Collection.new(['file-1.png', 'file-2.png'], sort_options, 'vertical', { global: { spacing: '5' }, images: { 'file-1' => { repeat: 'true' } } }) }

  before do
    allow(Spritely::ImageSet).to receive(:new).with('file-1.png', repeat: 'true').and_return(first_set)
    allow(Spritely::ImageSet).to receive(:new).with('file-2.png', spacing: '5').and_return(second_set)
    allow(Spritely::Layouts::Vertical).to receive(:new).with([first_set, second_set]).and_return(layout)
  end

  its(:files) { should eq(['file-1.png', 'file-2.png']) }
  its(:sort_options) { should eq(['name']) }
  its(:layout_key) { should eq('vertical') }
  its(:options) { should eq({ global: { spacing: '5' }, images: { 'file-1' => { repeat: 'true' } } }) }
  its(:images) { should eq([1, 2, 3]) }
  its(:width) { should eq(100) }
  its(:height) { should eq(110) }

  describe '.create' do
    let(:collection) { double }

    before { allow(Spritely::Collection).to receive(:new).with('something').and_return(collection) }

    it 'should attempt to generate the sprite' do
      expect(collection).to receive(:position!)
      expect(collection).to receive(:sort!)

      Spritely::Collection.create('something')
    end
  end

  describe '#find' do
    it 'should find the correct set by name' do
      expect(subject.find('foo')).to eq(first_set)
      expect(subject.find('bar')).to eq(second_set)
    end
  end

  describe '#cache_key' do
    before do
      allow(Digest::MD5).to receive(:hexdigest).with('file-1.png').and_return('foo1')
      allow(Digest::MD5).to receive(:hexdigest).with('file-2.png').and_return('bar1')
      allow(Digest::MD5).to receive(:file).with('file-1.png').and_return('foo2')
      allow(Digest::MD5).to receive(:file).with('file-2.png').and_return('bar2')
    end

    its(:cache_key) { should eq('foo1foo2bar1bar2') }
    its(:to_s) { should eq('foo1foo2bar1bar2') }
  end

  describe '#position!' do
    it 'should delegate to the layout' do
      expect(layout).to receive(:position!)

      subject.position!
    end
  end

  describe '#sort!' do
    let(:sort_options) { ['name'] }

    before { subject.sort! }

    its(:image_sets) { should eq([second_set, first_set]) }
  end
end
