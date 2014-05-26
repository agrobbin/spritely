require 'spec_helper'

describe Spritely::SpriteMap do
  let(:options_hash) { {'some_new_image_x' => 123, 'some_new_image_y' => 456, 'another_image_repeat' => true} }
  let(:options_object) { double(options: 'options', cache_key: 'options') }

  subject { Spritely::SpriteMap.new('test/*.png', options_hash) }

  before do
    Spritely.stub(:directory).and_return(File)
    allow(Spritely::Options).to receive(:new).with(options_hash).and_return(options_object)
  end

  it { should be_a(Sass::Script::Literal) }

  its(:glob) { should eq('test/*.png') }
  its(:options) { should eq(options_object) }
  its(:name) { should eq('test') }
  its(:filename) { should eq('test.png') }
  its(:inspect) { should eq("#<Spritely::SpriteMap name=test options=#{options_object.inspect}>") }

  describe '.create' do
    let(:sprite_map) { double(needs_generation?: true) }

    it 'should attempt to generate the sprite' do
      allow(Spritely::SpriteMap).to receive(:new).with('test/*.png').and_return(sprite_map)
      expect(sprite_map).to receive(:generate!)
      Spritely::SpriteMap.create('test/*.png')
    end
  end

  describe '#cache_key' do
    before { allow(subject).to receive(:collection).and_return(double(cache_key: 'collection value')) }

    its(:cache_key) { should eq('dfc047d12e4c6404e9dae98bc2851e5c') }
  end

  describe '#collection' do
    let(:collection) { double(find: 'find value', width: 'width value', height: 'height value', images: 'images value') }

    before do
      Spritely.stub_chain(:environment, :paths).and_return(["#{__dir__}/../fixtures"])
      allow(Spritely::Collection).to receive(:create).with(["#{__dir__}/../fixtures/test/foo.png"], options_object).and_return(collection)
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
        allow(subject).to receive(:cache_key).and_return('value')
        allow(Spritely::Cache).to receive(:busted?).with('test.png', 'value').and_return(true)
      end

      its(:needs_generation?) { should be_true }
    end
  end
end
