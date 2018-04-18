require 'spritely/image'

module Spritely
  # Each image in the sprite maps to an instance of `ImageSet` that stores the
  # image data, width, height, and outer positioning.
  class ImageSet
    attr_accessor :top
    attr_reader :path, :options, :data, :width, :height, :left

    def initialize(path, options)
      @path = path
      @options = options
      @data = File.read(path)
      @width, @height = data[0x10..0x18].unpack('NN')
      @left = 0
    end

    def name
      @name ||= File.basename(path, ".png")
    end

    def size
      @size ||= File.size(path)
    end

    def images
      @images ||= []
    end

    def outer_height
      spacing_before + height + spacing_after
    end

    def spacing_before
      options[:spacing_before].to_i
    end

    def spacing_after
      options[:spacing_after].to_i
    end

    def repeated?
      options[:repeat] == 'true'
    end

    def opposite?
      options[:opposite] == 'true'
    end

    # When positioned in the sprite, we must take into account whether the image
    # is configured to repeat, or is positioned to the opposite side of the
    # sprite map.
    def position_in!(collection_width)
      if repeated?
        left_position = 0
        while left_position < collection_width
          add_image!(left_position)
          left_position += width
        end
      elsif opposite?
        add_image!(@left = collection_width - width)
      else
        add_image!(0)
      end
    end

    private

    def add_image!(left_position)
      images << Image.new(data).tap do |image|
        image.top = top + spacing_before
        image.left = left_position
      end
    end
  end
end
