require 'spec_helper'

describe Spritely::SpriteMap do
  subject { Spritely::SpriteMap.new(double(value: 'test/*.png')) }

  before { Spritely.stub(:directory).and_return(File) }

  its(:glob) { should eq('test/*.png') }
  its(:name) { should eq('test') }
  its(:filename) { should eq('test.png') }

  describe '.create' do
    let(:sprite_map) { double(needs_generation?: true) }

    it 'should attempt to generate the sprite' do
      allow(Spritely::SpriteMap).to receive(:new).with('test/*.png').and_return(sprite_map)
      expect(sprite_map).to receive(:generate!)
      Spritely::SpriteMap.create('test/*.png')
    end
  end

  describe '#images' do
    before do
      Spritely.stub_chain(:environment, :paths).and_return(["#{__dir__}/../fixtures"])
      allow(Spritely::ImageSet).to receive(:new).with(["#{__dir__}/../fixtures/test/foo.png"]).and_return('images set')
    end

    its(:images) { should eq('images set') }
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
        subject.stub_chain(:images, :last_modification_time).and_return(456)
        allow(Spritely).to receive(:modification_time).and_return(123)
      end

      its(:needs_generation?) { should be_true }
    end
  end
end
