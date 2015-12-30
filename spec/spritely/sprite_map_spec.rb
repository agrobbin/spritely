require 'spec_helper'

describe Spritely::SpriteMap do
  let(:directives) { Set.new([
    ['x', 'some-new-image', '123'],
    ['y', 'some-new-image', '456'],
    ['repeat', 'another-image', 'true']
  ]) }
  let(:options) { double(options: 'options', cache_key: 'options') }
  let(:environment) { double(paths: ["#{__dir__}/../fixtures"]) }

  subject { Spritely::SpriteMap.new('test', environment, directives) }

  before { allow(Spritely::Options).to receive(:new).with(directives).and_return(options) }

  its(:name) { should eq('test') }
  its(:glob) { should eq('test/*.png') }
  its(:environment) { should eq(environment) }
  its(:options) { should eq(options) }
  its(:inspect) { should eq("#<Spritely::SpriteMap name=test options=#{options}>") }

  describe '#cache_key' do
    before { allow(subject).to receive(:collection).and_return(double(cache_key: 'collection cache value')) }

    its(:cache_key) { should eq('5651dbf274659c40bf471ba4dc3bbd06') }
  end

  describe '#collection' do
    let(:collection) { double(find: 'find value', width: 'width value', height: 'height value', images: 'images value') }

    before { allow(Spritely::Collection).to receive(:create).with(["#{__dir__}/../fixtures/test/foo.png"], options).and_return(collection) }

    its(:collection) { should eq(collection) }

    describe 'delegated methods' do
      its(:find) { should eq('find value') }
      its(:width) { should eq('width value') }
      its(:height) { should eq('height value') }
      its(:images) { should eq('images value') }
    end
  end

  describe '#save!' do
    let(:generator) { double }

    it 'should start the ChunkyPNG generator' do
      expect(Spritely::Generators::ChunkyPng).to receive(:new).with(subject).and_return(generator)
      expect(generator).to receive(:build!)

      subject.save!
    end
  end

  describe '#files' do
    its('files.length') { should eq(1) }
    its('files.first') { should match(/\.\.\/fixtures\/test\/foo\.png$/) }
  end
end
