require 'spec_helper'

describe Spritely::SpriteMap do
  let(:options) { {'some_new_image_x' => 123, 'some_new_image_y' => 456, 'another_image_repeat' => true} }

  subject { Spritely::SpriteMap.new('test/*.png', options) }

  before do
    Spritely.stub(:directory).and_return(File)
    allow(Spritely::Options).to receive(:new).with(options).and_return('options')
  end

  it { should be_a(Sass::Script::Literal) }

  its(:glob) { should eq('test/*.png') }
  its(:options) { should eq('options') }
  its(:name) { should eq('test') }
  its(:filename) { should eq('test.png') }
  its(:inspect) { should eq('#<Spritely::SpriteMap name=test filename=test.png>') }

  describe '.create' do
    let(:sprite_map) { double(needs_generation?: true) }

    it 'should attempt to generate the sprite' do
      allow(Spritely::SpriteMap).to receive(:new).with('test/*.png').and_return(sprite_map)
      expect(sprite_map).to receive(:generate!)
      Spritely::SpriteMap.create('test/*.png')
    end
  end

  describe '#collection' do
    let(:collection) { double(find: 'find value', width: 'width value', height: 'height value', images: 'images value') }

    before do
      Spritely.stub_chain(:environment, :paths).and_return(["#{__dir__}/../fixtures"])
      allow(Spritely::Collection).to receive(:create).with(["#{__dir__}/../fixtures/test/foo.png"], 'options').and_return(collection)
    end

    its(:collection) { should eq(collection) }

    describe 'delegated methods' do
      its(:find) { should eq('find value') }
      its(:width) { should eq('width value') }
      its(:height) { should eq('height value') }
      its(:images) { should eq('images value') }
    end
  end

  describe '#generate!' do
    it 'should start the ChunkyPNG generator' do
      expect(Spritely::Generators::ChunkyPng).to receive(:create!).with(subject)
      subject.generate!
    end
  end

  describe '#needs_generation?' do
    let(:file_exists) { false }

    before { allow(File).to receive(:exist?).with('test.png').and_return(file_exists) }

    its(:needs_generation?) { should be_true }

    context 'the sprite file already exists' do
      let(:file_exists) { true }

      before do
        subject.stub_chain(:collection, :last_modification_time).and_return(456)
        allow(Spritely).to receive(:modification_time).and_return(123)
      end

      its(:needs_generation?) { should be_true }
    end
  end
end
