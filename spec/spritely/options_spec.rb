require 'spec_helper'

describe Spritely::Options do
  let(:hash) { {
    'some_new_image_spacing' => Sass::Script::Number.new(789),
    'some_new_image_x' => Sass::Script::Number.new(123),
    'some_new_image_y' => Sass::Script::Number.new(456),
    'another_image_repeat' => Sass::Script::Bool.new(true),
    'yet_another_image_repeat' => Sass::Script::Bool.new(false),
    'spacing' => Sass::Script::Number.new(901),
  } }

  subject(:options) { Spritely::Options.new(hash) }

  its(:inspect) { should eq("#<Spritely::Options global_options=#{{spacing: 901}} options=#{{'some-new-image' => {spacing: 789, x: 123, y: 456}, 'another-image' => {spacing: 901, repeat: true}, 'yet-another-image' => {spacing: 901, repeat: false}}}>") }
  its(:cache_key) { should eq({some_new_image_spacing: 789, some_new_image_x: 123, some_new_image_y: 456, another_image_repeat: true, yet_another_image_repeat: false, spacing: 901}.to_s) }

  its(['some-new-image']) { should eq({spacing: 789, x: 123, y: 456}) }
  its(['another-image']) { should eq({spacing: 901, repeat: true}) }
  its(['yet-another-image']) { should eq({spacing: 901, repeat: false}) }

  describe '#[]' do
    it 'should fall back to an empty hash' do
      expect(options[:unknown]).to eq({spacing: 901})
    end
  end
end
