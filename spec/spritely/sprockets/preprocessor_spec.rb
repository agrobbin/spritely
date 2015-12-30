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

    expect(input[:metadata][:sprite_directives]).to eq(Set.new([
      ["spacing", "some-new-image", "789"],
      ["position", "some-new-image", "right"],
      ["repeat", "another-image", "true"],
      ["repeat", "yet-another-image", "false"],
      ["spacing", "901"],
      ["position", "left"]
    ]))
  end
end
