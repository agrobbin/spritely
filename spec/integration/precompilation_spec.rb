require 'spec_helper'
require 'active_support/core_ext/string'

describe 'Precompilation', :integration do
  it 'should create the sprite in the right location' do
    render_asset('sprites.css')
    expect(File.exist?(File.join('app', 'assets', 'images', 'sprites', 'application.png'))).to be_true
  end

  it 'should compile all of the assets necessary' do
    compile_assets
    sprite_files = Dir.glob(File.join('public', 'assets', 'sprites', 'application-*.png'))
    expect(sprite_files).to have(1).item
  end

  it 'should compile all of the assets necessary when sprites have been pre-generated' do
    render_asset('sprites.css')
    compile_assets
    sprite_files = Dir.glob(File.join('public', 'assets', 'sprites', 'application-*.png'))
    expect(sprite_files).to have(1).item
  end
end
