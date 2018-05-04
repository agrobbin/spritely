require 'spec_helper'
require 'active_support/core_ext/hash/except'

describe Spritely::SpriteMap do
  let(:directory) { nil }
  let(:sort) { nil }
  let(:layout) { nil }
  let(:options) { { directory: directory, sort: sort, layout: layout, global: {}, images: { 'some-new-image' => { x: '123', y: '456' }, 'another-image' => { repeat: 'true' } } } }
  let(:environment) { double(paths: ["#{__dir__}/../fixtures"]) }

  subject { Spritely::SpriteMap.new('test', environment, options) }

  its(:name) { should eq('test') }
  its(:environment) { should eq(environment) }
  its(:options) { should eq(options.except(:directory, :sort, :layout)) }
  its(:directory) { should eq('test') }
  its(:sort) { should eq(['name']) }
  its(:layout) { should eq('vertical') }
  its(:glob) { should eq('test/*.png') }
  its(:inspect) { should eq(%~#<Spritely::SpriteMap name=test directory=test sort=["name"] layout=vertical options=#{options.except(:directory, :sort, :layout)}>~) }

  context 'the directory is set' do
    let(:directory) { 'test/sprite-images' }

    its(:directory) { should eq('test/sprite-images') }
  end

  context 'the sort is set' do
    let(:sort) { ['name', 'desc'] }

    its(:sort) { should eq(['name', 'desc']) }
  end

  context 'the layout is set' do
    let(:layout) { 'horizontal' }

    its(:layout) { should eq('horizontal') }
  end

  describe '#cache_key' do
    before { allow(subject).to receive(:collection).and_return(double(to_s: 'collection cache value')) }

    its(:cache_key) { should eq('d9e141f6c3f40279f579b62a201c8f72') }
  end

  describe '#collection' do
    let(:collection) { double(find: 'find value', width: 'width value', height: 'height value', images: 'images value') }

    before { allow(Spritely::Collection).to receive(:create).with(["#{__dir__}/../fixtures/test/foo.png"], ['name'], 'vertical', options.except(:directory, :sort, :layout)).and_return(collection) }

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
