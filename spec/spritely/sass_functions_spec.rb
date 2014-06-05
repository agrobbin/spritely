require 'spec_helper'

describe Spritely::SassFunctions do
  class SpriteMapDouble < Sass::Script::Literal
    def name; 'test'; end
    def files; []; end
  end

  module AssetUrlModule
    def asset_url(path)
      Sass::Script::String.new("url(#{path})")
    end
  end

  let(:sprite_map) { SpriteMapDouble.new }
  let(:image) { double(left: 10, top: 12, width: 25, height: 50) }

  before do
    allow(Spritely::SpriteMap).to receive(:create).and_return(sprite_map)
    allow(sprite_map).to receive(:find).with('bar').and_return(image)
  end

  before(:all) { ::Sass::Script::Functions.send(:include, AssetUrlModule) }
  after(:all) { ::Sass::Script::Functions.send(:undef_method, :asset_url) }

  shared_examples "a sprite function that checks image existence" do
    let(:image) { nil }

    it 'should raise a nice exception' do
      expect { subject }.to raise_error(Sass::SyntaxError, "No image 'bar' found in sprite map 'test'.")
    end
  end

  describe '#spritely_url' do
    subject { evaluate("spritely-url(spritely-map('test/*.png'))") }

    it { should eq('url(sprites/test.png)') }
  end

  describe '#spritely_position' do
    subject { evaluate("spritely-position(spritely-map('test/*.png'), 'bar')") }

    it_should_behave_like "a sprite function that checks image existence"

    it { should eq('-10px -12px') }

    context 'the positions are both 0' do
      let(:image) { double(left: 0, top: 0) }

      it { should eq('0 0') }
    end
  end

  describe '#spritely_background' do
    subject { evaluate("spritely-background(spritely-map('test/*.png'), 'bar')") }

    it_should_behave_like "a sprite function that checks image existence"

    it { should eq('url(sprites/test.png) -10px -12px') }
  end

  describe '#spritely_width' do
    subject { evaluate("spritely-width(spritely-map('test/*.png'), 'bar')") }

    it_should_behave_like "a sprite function that checks image existence"

    it { should eq('25px') }
  end

  describe '#spritely_height' do
    subject { evaluate("spritely-height(spritely-map('test/*.png'), 'bar')") }

    it_should_behave_like "a sprite function that checks image existence"

    it { should eq('50px') }
  end

  def evaluate(value)
    Sass::Script::Parser.parse(value, 0, 0).perform(Sass::Environment.new).to_s
  end
end
