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

  describe '.modification_time' do
    before { allow(File).to receive(:mtime).with('foo').and_return('123') }

    it 'should give us the modification time' do
      expect(Spritely.modification_time('foo')).to eq(123)
    end
  end
end
