require 'spec_helper'

describe Spritely::SassFunctions do
  class SpriteMapDouble < Sass::Script::Literal
    def name; 'test'; end
    def files; []; end
  end

  let(:sprite_map) { SpriteMapDouble.new }

  before { allow(Spritely::SpriteMap).to receive(:create).and_return(sprite_map) }

  shared_examples "a sprite function that checks image existence" do
    before { allow(sprite_map).to receive(:find).with('bar').and_return(image) }

    context 'the image does not exist' do
      let(:image) { nil }

      it 'should raise a nice exception' do
        expect { subject }.to raise_error(Sass::SyntaxError, "No image 'bar' found in sprite map 'test'.")
      end
    end
  end

  describe '#spritely_url' do
    before do
      asset_url_module = Module.new do
        def asset_url(path)
          path
        end
      end
      ::Sass::Script::Functions.send(:include, asset_url_module)
    end

    after do
      ::Sass::Script::Functions.send(:undef_method, :asset_url)
    end

    it "should use Rails' built-in asset_url function" do
      expect(evaluate("spritely-url(spritely-map('test/*.png'))")).to eq('sprites/test.png')
    end
  end

  describe '#spritely_position' do
    let(:image) { double(left: 0, top: 12) }

    subject { evaluate("spritely-position(spritely-map('test/*.png'), 'bar')") }

    include_examples "a sprite function that checks image existence"

    it { should eq('0 -12px') }

    context 'the left is not 0' do
      let(:image) { double(left: 10, top: 12) }

      it { should eq('10px -12px') }
    end
  end

  describe '#spritely_width' do
    let(:image) { double(width: 25) }

    subject { evaluate("spritely-width(spritely-map('test/*.png'), 'bar')") }

    include_examples "a sprite function that checks image existence"

    it { should eq('25px') }
  end

  describe '#spritely_height' do
    let(:image) { double(height: 50) }

    subject { evaluate("spritely-height(spritely-map('test/*.png'), 'bar')") }

    include_examples "a sprite function that checks image existence"

    it { should eq('50px') }
  end

  def evaluate(value)
    Sass::Script::Parser.parse(value, 0, 0).perform(Sass::Environment.new).to_s
  end
end
