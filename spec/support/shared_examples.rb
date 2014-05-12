shared_examples "a generator" do
  class ImagesDouble
    def max_width; 100; end
    def total_height; 200; end

    def each(&block)
      [
        OpenStruct.new(data: 'first image data', left: 1, top: 10),
        OpenStruct.new(data: 'second image data', left: 2, top: 20)
      ].each(&block)
    end
  end

  let(:sprite_map) { double(images: ImagesDouble.new, filename: 'blah.png') }

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
    before { allow(Spritely).to receive(:directory).and_return('blah') }

    it 'should mkdir -p' do
      expect(FileUtils).to receive(:mkdir_p).with('blah')
      subject.ensure_directory_exists!
    end
  end
end
