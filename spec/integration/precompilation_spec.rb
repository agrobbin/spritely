require 'spec_helper'
require 'active_support/core_ext/string'

describe 'Precompilation', :integration do
  it 'should create the sprite in the right location' do
    render_asset('sprites.css')
    expect(File).to exist(File.join('app', 'assets', 'images', 'sprites', 'application.png'))
  end

  it 'should compile the correct-looking sprite file' do
    render_asset('sprites.css')
    compiled_sprite = ChunkyPNG::Image.from_file(File.join('app', 'assets', 'images', 'sprites', 'application.png'))
    correct_sprite = ChunkyPNG::Image.from_file(File.join(__dir__, '..', 'fixtures', 'correct-sprite.png'))
    expect(compiled_sprite).to eq(correct_sprite)
  end

  it 'should compile all of the assets necessary' do
    compile_assets
    sprite_files = Dir.glob(File.join('public', 'assets', 'sprites', 'application-*.png'))
    expect(sprite_files.length).to eq(1)
  end

  it 'should compile all of the assets necessary when sprites have been pre-generated' do
    render_asset('sprites.css')
    compile_assets
    sprite_files = Dir.glob(File.join('public', 'assets', 'sprites', 'application-*.png'))
    expect(sprite_files.length).to eq(1)
  end

  it 'should compile even if the sprite files no longer exist' do
    compile_assets
    FileUtils.rm_rf(Dir.glob(File.join('app', 'assets', 'images', 'sprites', '*.png')))
    compile_assets
    expect(File).to exist(File.join('app', 'assets', 'images', 'sprites', 'application.png'))
    expect(File).to exist(File.join('app', 'assets', 'images', 'sprites', 'foo.png'))
  end
end
