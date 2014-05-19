require 'spec_helper'

describe Spritely::Generators::ChunkyPng do
  let(:png_canvas) { double }

  subject { Spritely::Generators::ChunkyPng.new(sprite_map) }

  include_examples "a generator"

  before { allow(::ChunkyPNG::Image).to receive(:new).with(100, 200).and_return(png_canvas) }

  describe '#build!' do
    before do
      allow(::ChunkyPNG::Image).to receive(:from_blob).with('first image data').and_return('first image chunk')
      allow(::ChunkyPNG::Image).to receive(:from_blob).with('second image data').and_return('second image chunk')
    end

    it 'should append each image to the PNG canvas' do
      expect(png_canvas).to receive(:replace!).with('first image chunk', 1, 10)
      expect(png_canvas).to receive(:replace!).with('second image chunk', 2, 20)
      subject.build!
    end
  end

  describe '#save!' do
    it 'should save the PNG canvas' do
      expect(png_canvas).to receive(:save).with('blah.png', :fast_rgba)
      subject.save!
    end
  end
end
