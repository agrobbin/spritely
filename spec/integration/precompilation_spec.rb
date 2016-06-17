require 'spec_helper'

describe 'Precompilation', :integration do
  it 'should compile the correct-looking sprite file' do
    render_asset('sprites.css')
    runner %~Rails.application.assets["sprites/application.png"].write_to("compiled-sprite.png")~
    compiled_sprite = ChunkyPNG::Image.from_file('compiled-sprite.png')
    correct_sprite = ChunkyPNG::Image.from_file(File.join(__dir__, '..', 'fixtures', 'correct-sprite.png'))
    expect(compiled_sprite).to eq(correct_sprite)
  end

  it 'should compile all of the assets necessary' do
    compile_assets
    sprite_files = Dir.glob(File.join('public', 'assets', 'sprites', 'application-*.png'))
    expect(sprite_files.length).to eq(1)
  end

  it 'should compile a sprite that has no directives' do
    runner %~Rails.application.assets["sprites/empty.png"].write_to("compiled-sprite.png")~
    compiled_sprite = ChunkyPNG::Image.from_file('compiled-sprite.png')
    correct_sprite = ChunkyPNG::Image.from_file(File.join(__dir__, '..', 'fixtures', 'correct-empty-sprite.png'))
    expect(compiled_sprite).to eq(correct_sprite)
  end

  it 'should compile all of the assets necessary when sprites have been pre-generated' do
    render_asset('sprites.css')
    compile_assets
    sprite_files = Dir.glob(File.join('public', 'assets', 'sprites', 'application-*.png'))
    expect(sprite_files.length).to eq(1)
  end

  it 'should correctly compile a new sprite image and CSS when files change' do
    compile_assets
    FileUtils.cp_r "#{__dir__}/../fixtures/rails-app-changes/.", "."
    compile_assets
    sprite_files = Dir.glob(File.join('public', 'assets', 'sprites', 'application-*.png'))
    expect(sprite_files.length).to eq(2)
  end
end
