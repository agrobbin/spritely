require 'spec_helper'

describe Spritely do
  describe '.environment' do
    let(:application) { double(assets: 'assets environment') }

    before { stub_const('::Rails', double(application: application)) }

    its(:environment) { should eq('assets environment') }

    context 'sprockets-rails version 3' do
      before { stub_const('Sprockets::Rails::VERSION', '3.0.0') }

      its(:environment) { should eq('assets environment') }

      context 'the Rails application assets environment is nil' do
        let(:application) { double(assets: nil) }

        before { allow(::Sprockets::Railtie).to receive(:build_environment).with(application).and_return('new assets environment') }

        its(:environment) { should eq('new assets environment') }
      end
    end
  end

  describe '.directory' do
    before { stub_const('::Rails', double(root: Pathname.new('foo/bar'))) }

    its(:directory) { should eq(Pathname.new('foo/bar/app/assets/images/sprites')) }
  end

  describe '.relative_folder_path' do
    its(:relative_folder_path) { should eq(Pathname.new('app/assets/images/sprites')) }
  end

  describe '.sprockets_version' do
    before { stub_const('Sprockets::VERSION', '1.0') }

    its(:sprockets_version) { should eq(1) }
  end
end
