require 'spec_helper'

describe Spritely::Sprockets::Preprocessor do
  let(:data) { "//= spacing_below some-new-image 789\n//= opposite some-new-image true\n//= repeat another-image true\n//= repeat yet-another-image false\n//= spacing_below 901\n//= spacing_above 101" }
  let(:input) { {
    data: data,
    filename: "sprites/foo.png.sprite",
    metadata: {}
  } }

  subject(:preprocessor) { Spritely::Sprockets::Preprocessor.new(comments: ["//", ["/*", "*/"]]) }

  it 'saves the processed options as part of the metadata' do
    preprocessor._call(input)

    expect(input[:metadata][:sprite_directives]).to eq(
      directory: nil,
      sort: nil,
      global: { spacing_above: '101', spacing_below: '901' },
      images: {
        "some-new-image" => { spacing_above: '101', spacing_below: '789', opposite: 'true' },
        "another-image" => { repeat: 'true', spacing_above: '101', spacing_below: '901' },
        "yet-another-image" => { repeat: 'false', spacing_above: '101', spacing_below: '901' }
      }
    )
  end

  describe 'deprecation warnings' do
    describe 'position directive' do
      let(:data) { "//= position some-new-image right" }

      it 'warns the user' do
        expect(Spritely.logger).to receive(:warn).with('The `position` directive is deprecated and has been replaced by `opposite`. It will be removed in Spritely 3.0. (called from sprites/foo.png.sprite)')

        preprocessor._call(input)
      end
    end

    describe 'spacing directive' do
      let(:data) { "//= spacing 5" }

      it 'warns the user' do
        expect(Spritely.logger).to receive(:warn).with('The `spacing` directive is deprecated and has been replaced by `spacing_below`. It will be removed in Spritely 3.0. (called from sprites/foo.png.sprite)')

        preprocessor._call(input)

        expect(input[:metadata][:sprite_directives]).to eq(
          directory: nil,
          sort: nil,
          global: { spacing_below: '5' },
          images: {}
        )
      end
    end

    describe 'spacing-above directive' do
      let(:data) { "//= spacing-above 5" }

      it 'warns the user' do
        expect(Spritely.logger).to receive(:warn).with('The `spacing-above` directive is deprecated and has been replaced by `spacing_above`. It will be removed in Spritely 3.0. (called from sprites/foo.png.sprite)')

        preprocessor._call(input)

        expect(input[:metadata][:sprite_directives]).to eq(
          directory: nil,
          sort: nil,
          global: { spacing_above: '5' },
          images: {}
        )
      end
    end

    describe 'spacing-below directive' do
      let(:data) { "//= spacing-below 5" }

      it 'warns the user' do
        expect(Spritely.logger).to receive(:warn).with('The `spacing-below` directive is deprecated and has been replaced by `spacing_below`. It will be removed in Spritely 3.0. (called from sprites/foo.png.sprite)')

        preprocessor._call(input)

        expect(input[:metadata][:sprite_directives]).to eq(
          directory: nil,
          sort: nil,
          global: { spacing_below: '5' },
          images: {}
        )
      end
    end
  end

  describe 'overriding the directory' do
    let(:data) { "//= directory foo/sprites" }
    let(:input) { {
      data: data,
      filename: "sprites/foo.png.sprite",
      metadata: {}
    } }

    it 'saves the processed options as part of the metadata' do
      preprocessor._call(input)

      expect(input[:metadata][:sprite_directives]).to eq(
        directory: 'foo/sprites',
        sort: nil,
        global: {},
        images: {}
      )
    end
  end

  describe 'overriding the sorting' do
    let(:data) { "//= sort name desc" }
    let(:input) { {
      data: data,
      filename: "sprites/foo.png.sprite",
      metadata: {}
    } }

    it 'saves the processed options as part of the metadata' do
      preprocessor._call(input)

      expect(input[:metadata][:sprite_directives]).to eq(
        directory: nil,
        sort: ['name', 'desc'],
        global: {},
        images: {}
      )
    end

    context 'implicit direction' do
      let(:data) { "//= sort size" }

      it 'saves the processed options as part of the metadata' do
        preprocessor._call(input)

        expect(input[:metadata][:sprite_directives]).to eq(
          directory: nil,
          sort: ['size'],
          global: {},
          images: {}
        )
      end
    end
  end
end
