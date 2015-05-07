require 'spec_helper'
require 'sprockets'
require 'ostruct'

describe Spritely::SassFunctions, :sass_functions do
  class SpriteMapDouble < Sass::Script::Literal
    def name; 'test'; end
    def filename; 'test.png'; end
    def files; []; end
  end

  let(:directory) { __dir__ }
  let(:sprite_map) { SpriteMapDouble.new }
  let(:image) { double(left: 10, top: 12, width: 25, height: 50) }

  before do
    allow(Spritely).to receive(:directory).and_return(directory)
    allow(Spritely).to receive_message_chain(:sprockets_adapter, :reset_cache!)
    allow(Spritely::SpriteMap).to receive(:create).and_return(sprite_map)
    allow(sprite_map).to receive(:find).with('bar').and_return(image)
  end

  shared_examples "a sprite function that checks image existence" do
    let(:image) { nil }

    it 'should raise a nice exception' do
      expect { subject }.to raise_error(Sass::SyntaxError, "No image 'bar' found in sprite map 'test'.")
    end
  end

  shared_examples "a sprite function that resets the sprockets directory caches" do
    it 'should clear the Sprockets cache' do
      subject

      expect(Spritely.sprockets_adapter).to have_received(:reset_cache!).with(sprockets_environment, 'test.png')
    end
  end

  describe '#spritely_url' do
    subject { evaluate(".background-image { background-image: spritely-url(spritely-map('test/*.png')); }") }

    it_should_behave_like "a sprite function that resets the sprockets directory caches"

    it { should eq(".background-image {\n  background-image: url(sprites/test.png); }\n") }
  end

  describe '#spritely_position' do
    subject { evaluate(".background-position { background-position: spritely-position(spritely-map('test/*.png'), 'bar'); }") }

    it_should_behave_like "a sprite function that checks image existence"
    it_should_behave_like "a sprite function that resets the sprockets directory caches"

    it { should eq(".background-position {\n  background-position: -10px -12px; }\n") }

    context 'the positions are both 0' do
      let(:image) { double(left: 0, top: 0) }

      it { should eq(".background-position {\n  background-position: 0 0; }\n") }
    end
  end

  describe '#spritely_background' do
    subject { evaluate(".background { background: spritely-background(spritely-map('test/*.png'), 'bar'); }") }

    it_should_behave_like "a sprite function that checks image existence"
    it_should_behave_like "a sprite function that resets the sprockets directory caches"

    it { should eq(".background {\n  background: url(sprites/test.png) -10px -12px; }\n") }
  end

  describe '#spritely_width' do
    subject { evaluate(".width { width: spritely-width(spritely-map('test/*.png'), 'bar'); }") }

    it_should_behave_like "a sprite function that checks image existence"
    it_should_behave_like "a sprite function that resets the sprockets directory caches"

    it { should eq(".width {\n  width: 25px; }\n") }
  end

  describe '#spritely_height' do
    subject { evaluate(".height { height: spritely-height(spritely-map('test/*.png'), 'bar'); }") }

    it_should_behave_like "a sprite function that checks image existence"
    it_should_behave_like "a sprite function that resets the sprockets directory caches"

    it { should eq(".height {\n  height: 50px; }\n") }
  end
end
