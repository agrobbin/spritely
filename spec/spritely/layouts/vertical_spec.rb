require 'spec_helper'

describe Spritely::Layouts::Vertical do
  let(:first_image_set) { double(repeated?: true, opposite?: false, width: 5, spacing_before: 1, spacing_after: 2) }
  let(:second_image_set) { double(repeated?: false, opposite?: true, width: 10, spacing_before: 2, spacing_after: 4) }
  let(:third_image_set) { double(repeated?: false, opposite?: false, width: 20, spacing_before: 4, spacing_after: 8) }

  subject { Spritely::Layouts::Vertical.new([first_image_set, second_image_set, third_image_set]) }

  before do
    allow(first_image_set).to receive(:outer_size).with(:height).and_return(10)
    allow(second_image_set).to receive(:outer_size).with(:height).and_return(20)
    allow(third_image_set).to receive(:outer_size).with(:height).and_return(40)
  end

  describe '#position!' do
    before do
      allow(first_image_set).to receive_messages(add_image!: true, :left= => true, :top= => true)
      allow(second_image_set).to receive_messages(add_image!: true, :left= => true, :top= => true)
      allow(third_image_set).to receive_messages(add_image!: true, :left= => true, :top= => true)
    end

    before { subject.position! }

    it 'should set the positions of the images' do
      expect(first_image_set).to have_received(:top=).with(0)
      expect(first_image_set).to_not have_received(:left=)
      expect(first_image_set).to have_received(:add_image!).exactly(4).times
      expect(first_image_set).to have_received(:add_image!).with(1, 0)
      expect(first_image_set).to have_received(:add_image!).with(1, 5)
      expect(first_image_set).to have_received(:add_image!).with(1, 10)
      expect(first_image_set).to have_received(:add_image!).with(1, 15)

      expect(second_image_set).to have_received(:top=).with(10)
      expect(second_image_set).to have_received(:left=).with(10)
      expect(second_image_set).to have_received(:add_image!).once
      expect(second_image_set).to have_received(:add_image!).with(2, 0)

      expect(third_image_set).to have_received(:top=).with(30)
      expect(third_image_set).to_not have_received(:left=)
      expect(third_image_set).to have_received(:add_image!).once
      expect(third_image_set).to have_received(:add_image!).with(4, 0)
    end
  end

  describe '#width' do
    its(:width) { should eq(20) }

    context 'when the repetition will overflow the largest non-repeating image' do
      let(:first_image_set) { double(repeated?: true, width: 12) }
      let(:second_image_set) { double(repeated?: false, width: 100) }

      its(:width) { should eq(108) }
    end

    context 'when there are multiple repeating images, find the lcm' do
      let(:first_image_set) { double(repeated?: true, width: 12) }
      let(:second_image_set) { double(repeated?: true, width: 100) }
      let(:third_image_set) { double(repeated?: true, width: 65) }

      its(:width) { should eq(3900) }
    end

    context 'when there is a mix of repeating and non-repeating' do
      let(:first_image_set) { double(repeated?: true, width: 12) }
      let(:second_image_set) { double(repeated?: false, width: 100) }
      let(:third_image_set) { double(repeated?: true, width: 5) }

      its(:width) { should eq(120) }
    end
  end

  describe '#height' do
    its(:height) { should eq(70) }
  end
end
