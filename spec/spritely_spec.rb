require 'spec_helper'

describe Spritely do
  describe '.environment' do
    before { stub_const('::Rails', double(application: double(assets: 'assets environment'))) }

    its(:environment) { should eq('assets environment') }
  end

  describe '.directory' do
    before { stub_const('::Rails', double(root: Pathname.new('foo/bar'))) }

    its(:directory) { should eq(Pathname.new('foo/bar/app/assets/images/sprites')) }
  end

  describe '.relative_folder_path' do
    its(:relative_folder_path) { should eq(Pathname.new('app/assets/images/sprites')) }
  end
end
