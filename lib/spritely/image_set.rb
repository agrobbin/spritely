require 'spritely/image'

module Spritely
  class ImageSet
    attr_accessor :top
    attr_reader :path, :options, :data, :width, :height

    def initialize(path, options)
      @path = path
      @options = options
      @data = File.read(path)
      @width, @height = data[0x10..0x18].unpack('NN')
    end

    def name
      File.basename(path, ".png")
    end

    def images
      @images ||= []
    end

    def left
      0
    end

    def outer_height
      height + spacing
    end

    def spacing
      options[:spacing] || 0
    end

    def repeated?
      !!options[:repeat]
    end

    def position_in!(collection_width)
      if repeated?
        left_position = 0
        while left_position < collection_width
          add_image!(left_position)
          left_position += width
        end
      else
        add_image!(0)
      end
    end

    private

    def add_image!(left_position)
      images << Image.new(data).tap do |image|
        image.top = top
        image.left = left_position
      end
    end
  end
end
