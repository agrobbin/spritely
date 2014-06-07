require 'spec_helper'
require 'active_support/core_ext/string/strip'

describe 'Stylesheet generation', :integration do
  subject(:stylesheet) { render_asset('sprites.css') }

  describe 'body CSS with repetition' do
    it { should include(<<-CSS.strip_heredoc
      body {
        background-image: url(/assets/sprites/application.png);
        background-position: 0 -952px;
      }
    CSS
    ) }
  end

  describe '#mario CSS with no repetition' do
    it { should include(<<-CSS.strip_heredoc
      #mario {
        background-image: url(/assets/sprites/application.png);
        background-position: -150px -728px;
        width: 200px;
        height: 214px;
      }
    CSS
    ) }
  end

  describe 'multiple sprite maps across files' do
    it 'should produce the correct asset URL for both sprites' do
      compile_assets
      compiled_css = File.read(Dir.glob(File.join('public', 'assets', 'application-*.css')).first)
      expect(compiled_css).to include('url(/assets/sprites/application')
      expect(compiled_css).to include('url(/assets/sprites/foo')
      expect(compiled_css).to_not include('url(/sprites/')
    end
  end
end
