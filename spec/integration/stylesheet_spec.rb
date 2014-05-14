require 'spec_helper'

describe 'Stylesheet generation', :integration do
  it 'should generate the correct compiled stylesheet' do
    sprite_css = render_asset('sprites.css')
    expect(sprite_css).to include('background-image: url(/assets/sprites/application.png);')
    expect(sprite_css).to include('background-position: 0 -623px;')
    expect(sprite_css).to include('width: 200px;')
    expect(sprite_css).to include('height: 214px;')
  end
end
