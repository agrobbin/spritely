require 'spec_helper'

describe Spritely::Layouts::Horizontal do
  let(:first_image_set) { double(repeated?: true, opposite?: false, height: 5, spacing_before: 1, spacing_after: 2) }
  let(:second_image_set) { double(repeated?: false, opposite?: true, height: 10, spacing_before: 2, spacing_after: 4) }
  let(:third_image_set) { double(repeated?: false, opposite?: false, height: 20, spacing_before: 4, spacing_after: 8) }

  subject { Spritely::Layouts::Horizontal.new([first_image_set, second_image_set, third_image_set]) }

  before do
    allow(first_image_set).to receive(:outer_size).with(:width).and_return(10)
    allow(second_image_set).to receive(:outer_size).with(:width).and_return(20)
    allow(third_image_set).to receive(:outer_size).with(:width).and_return(40)
  end

  describe '#position!' do
    before do
      allow(first_image_set).to receive_messages(add_image!: true, :left= => true, :top= => true)
      allow(second_image_set).to receive_messages(add_image!: true, :left= => true, :top= => true)
      allow(third_image_set).to receive_messages(add_image!: true, :left= => true, :top= => true)
    end

    before { subject.position! }

    it 'should set the positions of the images' do
      expect(first_image_set).to have_received(:left=).with(0)
      expect(first_image_set).to_not have_received(:top=)
      expect(first_image_set).to have_received(:add_image!).exactly(4).times
      expect(first_image_set).to have_received(:add_image!).with(0, 1)
      expect(first_image_set).to have_received(:add_image!).with(5, 1)
      expect(first_image_set).to have_received(:add_image!).with(10, 1)
      expect(first_image_set).to have_received(:add_image!).with(15, 1)

      expect(second_image_set).to have_received(:left=).with(10)
      expect(second_image_set).to have_received(:top=).with(10)
      expect(second_image_set).to have_received(:add_image!).once
      expect(second_image_set).to have_received(:add_image!).with(0, 2)

      expect(third_image_set).to have_received(:left=).with(30)
      expect(third_image_set).to_not have_received(:top=)
      expect(third_image_set).to have_received(:add_image!).once
      expect(third_image_set).to have_received(:add_image!).with(0, 4)
    end
  end

  describe '#width' do
    its(:width) { should eq(70) }
  end

  describe '#height' do
    subject { Spritely::Layouts::Horizontal.new([first_image_set, second_image_set, third_image_set]) }

    its(:height) { should eq(20) }

    context 'when the repetition will overflow the largest non-repeating image' do
      let(:first_image_set) { double(repeated?: true, height: 12) }
      let(:second_image_set) { double(repeated?: false, height: 100) }

      its(:height) { should eq(108) }
    end

    context 'when there are multiple repeating images, find the lcm' do
      let(:first_image_set) { double(repeated?: true, height: 12) }
      let(:second_image_set) { double(repeated?: true, height: 100) }
      let(:third_image_set) { double(repeated?: true, height: 65) }

      its(:height) { should eq(3900) }
    end

    context 'when there is a mix of repeating and non-repeating' do
      let(:first_image_set) { double(repeated?: true, height: 12) }
      let(:second_image_set) { double(repeated?: false, height: 100) }
      let(:third_image_set) { double(repeated?: true, height: 5) }

      its(:height) { should eq(120) }
    end
  end
end
