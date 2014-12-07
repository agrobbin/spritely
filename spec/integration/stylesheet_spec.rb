require 'spec_helper'
require 'active_support/core_ext/string/strip'

describe 'Stylesheet generation', :integration do
  subject!(:stylesheet) { render_asset('sprites.css') }

  let!(:background_image_url) { spite_image_path("application") }

  describe 'body CSS with repetition' do
    it { should include(<<-CSS.strip_heredoc
      body {
        background-image: url(#{background_image_url});
        background-position: 0 0;
      }
    CSS
    ) }
  end

  describe '#mario CSS with no repetition' do
    it { should include(<<-CSS.strip_heredoc
      #mario {
        background-image: url(#{background_image_url});
        background-position: -150px -806px;
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
