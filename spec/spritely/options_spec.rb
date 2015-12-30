require 'spec_helper'

describe Spritely::Options do
  let(:set) { Set.new([
    ['spacing', 'some-new-image', '789'],
    ['x', 'some-new-image', '123'],
    ['y', 'some-new-image', '456'],
    ['position', 'some-new-image', 'right'],
    ['repeat', 'another-image', 'true'],
    ['repeat', 'yet-another-image', 'false'],
    ['spacing', '901'],
    ['position', 'left']
  ]) }

  subject(:options) { Spritely::Options.new(set) }

  its(:inspect) { should eq("#<Spritely::Options global_options=#{{spacing: '901', position: 'left'}} options=#{{'some-new-image' => {spacing: '789', position: 'right', x: '123', y: '456'}, 'another-image' => {spacing: '901', position: 'left', repeat: 'true'}, 'yet-another-image' => {spacing: '901', position: 'left', repeat: 'false'}}}>") }
  its(:cache_key) { should eq({'some-new-image_spacing' => '789', 'some-new-image_x' => '123', 'some-new-image_y' => '456', 'some-new-image_position' => 'right', 'another-image_repeat' => 'true', 'yet-another-image_repeat' => 'false', 'spacing' => '901', 'position' => 'left'}.to_s) }

  its(['some-new-image']) { should eq({spacing: '789', position: 'right', x: '123', y: '456'}) }
  its(['another-image']) { should eq({spacing: '901', repeat: 'true', position: 'left'}) }
  its(['yet-another-image']) { should eq({spacing: '901', repeat: 'false', position: 'left'}) }

  describe '#[]' do
    it 'should fall back to the global options' do
      expect(options['unknown']).to eq({spacing: '901', position: 'left'})
    end
  end
end
