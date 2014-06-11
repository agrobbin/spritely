shared_examples "a generator" do
  let(:images) { [OpenStruct.new(data: 'first image data', left: 1, top: 10), OpenStruct.new(data: 'second image data', left: 2, top: 20)] }
  let(:sprite_map) { double(images: images, width: 100, height: 200, filename: 'blah.png', cache_key: 'cachevalue') }

  its(:sprite_map) { should eq(sprite_map) }

  describe '.create!' do
    let(:generator) { double }

    before { allow(described_class).to receive(:new).with(sprite_map).and_return(generator) }

    it 'should work some magic' do
      expect(generator).to receive(:build!)
      expect(generator).to receive(:ensure_directory_exists!)
      expect(generator).to receive(:save!)
      described_class.create!(sprite_map)
    end
  end

  describe '#ensure_directory_exists!' do
    let(:directory_exists) { true }

    before do
      allow(Spritely).to receive(:directory).and_return('blah')
      allow(File).to receive(:exist?).with('blah').and_return(directory_exists)
    end

    it 'should not raise an exception' do
      expect { subject.ensure_directory_exists! }.to_not raise_error
    end

    context 'the sprites folder does not exist' do
      let(:directory_exists) { false }

      it 'should raise an exception' do
        expect { subject.ensure_directory_exists! }.to raise_error("'app/assets/images/sprites' doesn't exist. Run `rails generate spritely:install`.")
      end
    end
  end
end
