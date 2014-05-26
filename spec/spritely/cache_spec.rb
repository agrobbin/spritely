require 'spec_helper'

describe Spritely::Cache do
  let(:filename) { File.join(__dir__, '..', 'fixtures', 'test', 'foo.png') }

  subject { Spritely::Cache.new(filename) }

  its(:filename) { should eq(filename) }
  its(:key) { should eq('527272411fe99a8b5e9da254ac0aae88') }

  describe '.generate' do
    it 'should collect the cache_key values and digest them' do
      expect(Spritely::Cache.generate(double(cache_key: 'asdf'), double(cache_key: 'hjkl'))).to eq('527272411fe99a8b5e9da254ac0aae88')
    end
  end

  describe '.busted?' do
    it 'should check the expected value against the real value' do
      expect(Spritely::Cache).to be_busted(filename, 'asdf')
    end
  end
end
