require 'spec_helper'
require 'ostruct'

describe Spritely::Generators::ChunkyPng do
  let(:png_canvas) { double(metadata: {}, to_blob: "final PNG content") }
  let(:images) { [OpenStruct.new(data: 'first image data', left: 1, top: 10), OpenStruct.new(data: 'second image data', left: 2, top: 20)] }
  let(:sprite_map) { double(images: images, width: 100, height: 200, filename: 'blah.png', cache_key: 'cachevalue') }

  subject { Spritely::Generators::ChunkyPng.new(sprite_map) }

  before { allow(::ChunkyPNG::Image).to receive(:new).with(100, 200).and_return(png_canvas) }

  its(:sprite_map) { should eq(sprite_map) }

  describe '#build!' do
    before do
      allow(::ChunkyPNG::Image).to receive(:from_blob).with('first image data').and_return('first image chunk')
      allow(::ChunkyPNG::Image).to receive(:from_blob).with('second image data').and_return('second image chunk')
    end

    it 'should append each image to the PNG canvas and output to string' do
      expect(png_canvas).to receive(:replace!).with('first image chunk', 1, 10)
      expect(png_canvas).to receive(:replace!).with('second image chunk', 2, 20)
      expect(png_canvas).to receive(:to_blob).with(:fast_rgba)
      expect(subject.build!).to eq('final PNG content')
    end
  end
end
