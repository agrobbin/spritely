require 'spec_helper'

describe Spritely::Options do
  let(:hash) { {
    'some_new_image_x' => Sass::Script::Number.new(123),
    'some_new_image_y' => Sass::Script::Number.new(456),
    'another_image_repeat' => Sass::Script::Bool.new(true),
    'yet_another_image_repeat' => Sass::Script::Bool.new(false)
  } }

  subject(:options) { Spritely::Options.new(hash) }

  its(['some-new-image']) { should eq({x: 123, y: 456}) }
  its(['another-image']) { should eq({repeat: true}) }
  its(['yet-another-image']) { should eq({repeat: false}) }

  describe '#[]' do
    it 'should fall back to an empty hash' do
      expect(options[:unknown]).to eq({})
    end
  end
end
