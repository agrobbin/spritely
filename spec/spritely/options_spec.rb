require 'spec_helper'

describe Spritely::Options do
  let(:hash) { {'some_new_image_x' => 123, 'some_new_image_y' => 456, 'another_image_repeat' => true} }

  subject(:options) { Spritely::Options.new(hash) }

  its(['some-new-image']) { should eq({x: 123, y: 456}) }
  its(['another-image']) { should eq({repeat: true}) }

  describe '#[]' do
    it 'should fall back to an empty hash' do
      expect(options[:unknown]).to eq({})
    end
  end
end
