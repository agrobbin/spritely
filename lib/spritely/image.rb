module Spritely
  class Image
    attr_accessor :top
    attr_reader :path, :data, :width, :height

    def initialize(path)
      @path = path
      @data = File.read(path)
      @width, @height = data[0x10..0x18].unpack('NN')
    end

    def left
      0
    end

    def name
      File.basename(path, ".png")
    end
  end
end
