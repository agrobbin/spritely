require 'spec_helper'

describe Spritely::Sprockets::Preprocessor do
  let(:data) { "//= spacing some-new-image 789\n//= position some-new-image right\n//= repeat another-image true\n//= repeat yet-another-image false\n//= spacing 901\n//= position left" }
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
      global: { spacing: '901', position: 'left' },
      images: {
        "some-new-image" => { spacing: '789', position: 'right' },
        "another-image" => { repeat: 'true', spacing: '901', position: 'left' },
        "yet-another-image" => { repeat: 'false', spacing: '901', position: 'left' }
      }
    )
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

  describe 'invalid global option' do
    let(:data) { "//= repeat true" }

    it 'raises an exception' do
      expect { preprocessor._call(input) }.to raise_error(ArgumentError, "'repeat' is not a valid global option")
    end
  end
end
