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
        background-position: 0 -728px;
        width: 200px;
        height: 214px;
      }
    CSS
    ) }
  end
end
