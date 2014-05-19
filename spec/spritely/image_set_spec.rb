require 'spec_helper'
require 'ostruct'

describe Spritely::ImageSet do
  let(:path) { "#{__dir__}/../fixtures/test/foo.png" }
  let(:options) { {repeat: true} }

  subject { Spritely::ImageSet.new(path, options) }

  its(:path) { should eq(path) }
  its(:options) { should eq(options) }
  its(:data) { should eq(File.read(path)) }
  its(:width) { should eq(1) }
  its(:height) { should eq(1) }
  its(:name) { should eq('foo') }
  its(:left) { should eq(0) }

  describe '#top' do
    before { subject.top = 123 }

    its(:top) { should eq(123) }
  end

  describe '#repeated?' do
    it { should be_repeated }

    context 'repeat option is passed as truthy' do
      let(:options) { {repeat: 'repeat'} }

      it { should be_repeated }
    end

    context 'repeat option is passed as false' do
      let(:options) { {repeat: false} }

      it { should_not be_repeated }
    end

    context 'repeat option is not passed' do
      let(:options) { {} }

      it { should_not be_repeated }
    end
  end

  describe '#position_in!' do
    class ImageDouble
      attr_accessor :top, :left
    end

    before { subject.top = 123 }

    context 'the image is repeated' do
      let(:first_image) { ImageDouble.new }
      let(:second_image) { ImageDouble.new }

      before do
        allow(Spritely::Image).to receive(:new).with(File.read(path)).and_return(first_image, second_image)
        subject.position_in!(2)
      end

      it 'should set the position of the images' do
        expect(first_image.top).to eq(123)
        expect(first_image.left).to eq(0)
        expect(second_image.top).to eq(123)
        expect(second_image.left).to eq(1)
      end
    end

    context 'the image is not repeated' do
      let(:options) { {repeat: false} }
      let(:image) { ImageDouble.new }

      before do
        allow(Spritely::Image).to receive(:new).with(File.read(path)).and_return(image)
        subject.position_in!(1)
      end

      it 'should set the position of the image' do
        expect(image.top).to eq(123)
        expect(image.left).to eq(0)
      end
    end
  end
end
