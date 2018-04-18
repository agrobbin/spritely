require 'spec_helper'
require 'ostruct'

describe Spritely::ImageSet do
  let(:path) { "#{__dir__}/../fixtures/test/foo.png" }
  let(:options) { {repeat: 'true', spacing_above: '5', spacing_below: '10', opposite: 'true'} }

  subject { Spritely::ImageSet.new(path, options) }

  its(:path) { should eq(path) }
  its(:options) { should eq(options) }
  its(:data) { should eq(File.read(path)) }
  its(:size) { should eq(121) }
  its(:width) { should eq(1) }
  its(:height) { should eq(1) }
  its(:name) { should eq('foo') }
  its(:left) { should eq(0) }
  its(:spacing_above) { should eq(5) }
  its(:spacing_below) { should eq(10) }
  its(:outer_height) { should eq(16) }

  describe '#top' do
    before { subject.top = 123 }

    its(:top) { should eq(123) }
  end

  describe '#repeated?' do
    it { should be_repeated }

    context 'repeat option is passed as false' do
      let(:options) { {repeat: false} }

      it { should_not be_repeated }
    end

    context 'repeat option is not passed' do
      let(:options) { {} }

      it { should_not be_repeated }
    end
  end

  describe '#opposite?' do
    it { should be_opposite }

    context 'position option is passed as false' do
      let(:options) { { position: 'false' } }

      it { should_not be_opposite }
    end

    context 'position option is not passed' do
      let(:options) { {} }

      it { should_not be_opposite }
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
        expect(first_image.top).to eq(128)
        expect(first_image.left).to eq(0)
        expect(second_image.top).to eq(128)
        expect(second_image.left).to eq(1)
      end

      context 'it is also positioned to the opposite side' do
        let(:options) { {opposite: 'true', repeat: 'true'} }

        its(:left) { should eq(0) }

        it 'should ignore the opposite option' do
          expect(first_image.top).to eq(123)
          expect(first_image.left).to eq(0)
          expect(second_image.top).to eq(123)
          expect(second_image.left).to eq(1)
        end
      end
    end

    context 'the image is positioned to the right' do
      let(:options) { {opposite: 'true'} }
      let(:image) { ImageDouble.new }

      before do
        allow(Spritely::Image).to receive(:new).with(File.read(path)).and_return(image)
        subject.position_in!(100)
      end

      its(:left) { should eq(99) }

      it 'should set the position of the image' do
        expect(image.top).to eq(123)
        expect(image.left).to eq(99)
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
