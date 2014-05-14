require 'spec_helper'
require 'ostruct'

describe Spritely::ImageSet do
  class ImageDouble < OpenStruct
    attr_accessor :top
  end

  let(:first_image) { ImageDouble.new(name: 'foo', width: 1, height: 10) }
  let(:second_image) { ImageDouble.new(name: 'bar', width: 100, height: 100) }

  before do
    allow(Spritely::Image).to receive(:new).with('first').and_return(first_image)
    allow(Spritely::Image).to receive(:new).with('second').and_return(second_image)
  end

  subject! { Spritely::ImageSet.new(['first', 'second']) }

  its(:files) { should eq(['first', 'second']) }
  its(:images) { should eq([second_image, first_image]) }
  its(:max_width) { should eq(100) }
  its(:total_height) { should eq(110) }

  describe 'positioning' do
    it 'should set the #top position of each image' do
      expect(first_image.top).to eq(100)
      expect(second_image.top).to eq(0)
    end
  end

  describe '#each delegation' do
    it 'should pass along the #each method call to the internal #images array' do
      expect(first_image).to receive(:blah!)
      expect(second_image).to receive(:blah!)
      subject.each(&:blah!)
    end
  end

  describe '#find' do
    it 'should find the correct image by name' do
      expect(subject.find('foo')).to eq(first_image)
      expect(subject.find('bar')).to eq(second_image)
    end
  end

  describe '#last_modification_time' do
    before do
      allow(Spritely).to receive(:modification_time).with('first').and_return(10)
      allow(Spritely).to receive(:modification_time).with('second').and_return(100)
    end

    its(:last_modification_time) { should eq(100) }
  end
end
