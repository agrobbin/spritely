require 'spec_helper'

describe Spritely::Sprockets::Preprocessor do
  let(:data) { "//= spacing-below some-new-image 789\n//= position some-new-image right\n//= repeat another-image true\n//= repeat yet-another-image false\n//= spacing-below 901\n//= spacing-above 101\n//= position left" }
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
      global: { spacing_above: '101', spacing_below: '901', position: 'left' },
      images: {
        "some-new-image" => { spacing_above: '101', spacing_below: '789', position: 'right' },
        "another-image" => { repeat: 'true', spacing_above: '101', spacing_below: '901', position: 'left' },
        "yet-another-image" => { repeat: 'false', spacing_above: '101', spacing_below: '901', position: 'left' }
      }
    )
  end

  describe 'deprecation warnings' do
    describe 'spacing directive' do
      let(:data) { "//= spacing 5" }

      it 'warns the user' do
        expect(Spritely.logger).to receive(:warn).with('The `spacing` directive is deprecated and has been replaced by `spacing-below`. It will be removed in Spritely 3.0. (called from sprites/foo.png.sprite)')

        preprocessor._call(input)

        expect(input[:metadata][:sprite_directives]).to eq(
          directory: nil,
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
        global: {},
        images: {}
      )
    end
  end
end
