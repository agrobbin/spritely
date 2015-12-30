require 'spec_helper'
require 'sprockets'

describe Spritely::SassFunctions do
  let(:asset) { double(metadata: { sprite_directives: 'directives' }) }
  let(:sprite_map) { double(name: 'test') }
  let(:image) { double(left: 10, top: 12, width: 25, height: 50) }

  before do
    allow(sprockets_environment).to receive(:find_asset).with('sprites/test.png.sprite').and_return(asset)
    allow(Spritely::SpriteMap).to receive(:new).with('test', sprockets_environment, 'directives').and_return(sprite_map)
    allow(sprite_map).to receive(:find).with('bar').and_return(image)
  end

  shared_examples "a sprite function that checks sprite map and image existence" do
    context "the sprite map doesn't exist" do
      let(:asset) { nil }

      it 'should raise a nice exception' do
        expect { subject }.to raise_error(Sass::SyntaxError, "No sprite map 'test' found.")
      end
    end

    context "the image doesn't exist in the sprite map" do
      let(:image) { nil }

      it 'should raise a nice exception' do
        expect { subject }.to raise_error(Sass::SyntaxError, "No image 'bar' found in sprite map 'test'.")
      end
    end
  end

  describe '#spritely_url' do
    subject { evaluate(".background-image { background-image: spritely-url('test'); }") }

    it { should eq(".background-image {\n  background-image: url(sprites/test.png); }\n") }
  end

  describe '#spritely_position' do
    subject { evaluate(".background-position { background-position: spritely-position('test', 'bar'); }") }

    it_should_behave_like "a sprite function that checks sprite map and image existence"

    it { should eq(".background-position {\n  background-position: -10px -12px; }\n") }

    context 'the positions are both 0' do
      let(:image) { double(left: 0, top: 0) }

      it { should eq(".background-position {\n  background-position: 0 0; }\n") }
    end
  end

  describe '#spritely_background' do
    subject { evaluate(".background { background: spritely-background('test', 'bar'); }") }

    it_should_behave_like "a sprite function that checks sprite map and image existence"

    it { should eq(".background {\n  background: url(sprites/test.png) -10px -12px; }\n") }
  end

  describe '#spritely_width' do
    subject { evaluate(".width { width: spritely-width('test', 'bar'); }") }

    it_should_behave_like "a sprite function that checks sprite map and image existence"

    it { should eq(".width {\n  width: 25px; }\n") }
  end

  describe '#spritely_height' do
    subject { evaluate(".height { height: spritely-height('test', 'bar'); }") }

    it_should_behave_like "a sprite function that checks sprite map and image existence"

    it { should eq(".height {\n  height: 50px; }\n") }
  end

  def evaluate(value)
    Sprockets::ScssProcessor.call(environment: sprockets_environment, data: value, filename: "test.scss", metadata: {}, cache: Sprockets::Cache.new)[:data]
  end

  def sprockets_environment
    @sprockets_environment ||= Sprockets::CachedEnvironment.new(Sprockets::Environment.new).tap do |sprockets_environment|
      sprockets_environment.context_class.class_eval do
        def link_asset(path); end
        def asset_path(path, options = {}); path; end
      end
    end
  end
end
