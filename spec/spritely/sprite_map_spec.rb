require 'spec_helper'

describe Spritely::SpriteMap do
  let(:options_hash) { {'some_new_image_x' => 123, 'some_new_image_y' => 456, 'another_image_repeat' => true} }
  let(:options_object) { double(options: 'options', cache_key: 'options') }

  subject { Spritely::SpriteMap.new('test/*.png', options_hash) }

  before do
    allow(Spritely).to receive_message_chain(:environment, :paths).and_return(["#{__dir__}/../fixtures"])
    allow(Spritely).to receive(:directory).and_return(File)
    allow(Spritely::Options).to receive(:new).with(options_hash).and_return(options_object)
  end

  it { should be_a(Sass::Script::Literal) }

  its(:glob) { should eq('test/*.png') }
  its(:options) { should eq(options_object) }
  its(:name) { should eq('test') }
  its(:filename) { should eq('test.png') }
  its(:inspect) { should eq("#<Spritely::SpriteMap name=test options=#{options_object}>") }

  describe '.create' do
    let(:sprite_map) { double(needs_generation?: true) }

    it 'should attempt to generate the sprite' do
      allow(Spritely::SpriteMap).to receive(:new).with('test/*.png').and_return(sprite_map)
      expect(sprite_map).to receive(:generate!)
      Spritely::SpriteMap.create('test/*.png')
    end
  end

  describe '#cache_key' do
    before do
      allow(subject).to receive(:collection).and_return('collection value')
      allow(Spritely::Cache).to receive(:generate).with(options_object, 'collection value').and_return('cache value')
    end

    its(:cache_key) { should eq('cache value') }
  end

  describe '#collection' do
    let(:collection) { double(find: 'find value', width: 'width value', height: 'height value', images: 'images value') }

    before { allow(Spritely::Collection).to receive(:create).with(["#{__dir__}/../fixtures/test/foo.png"], options_object).and_return(collection) }

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

    its(:needs_generation?) { should be_truthy }

    context 'the sprite file already exists' do
      let(:file_exists) { true }

      before do
        allow(subject).to receive(:cache_key).and_return('value')
        allow(Spritely::Cache).to receive(:busted?).with('test.png', 'value').and_return(true)
      end

      its(:needs_generation?) { should be_truthy }
    end
  end

  describe '#files' do
    its('files.length') { should eq(1) }
    its('files.first') { should match(/\.\.\/fixtures\/test\/foo\.png$/) }
  end
end
