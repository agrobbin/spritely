require 'spec_helper'

describe Spritely do
  describe '.environment' do
    before { stub_const('::Rails', double(application: double(assets: 'assets environment'))) }

    its(:environment) { should eq('assets environment') }
  end

  describe '.directory' do
    before { stub_const('::Rails', double(root: File)) }

    its(:directory) { should eq('app/assets/images/sprites') }
  end
end
