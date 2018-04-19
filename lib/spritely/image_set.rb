require 'spritely/image'

module Spritely
  # Each image in the sprite maps to an instance of `ImageSet` that stores the
  # image data, width, height, and outer positioning.
  class ImageSet
    attr_accessor :top, :left
    attr_reader :path, :options, :data, :width, :height

    def initialize(path, options)
      @path = path
      @options = options
      @data = File.read(path)
      @width, @height = data[0x10..0x18].unpack('NN')
      @top = 0
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

    def outer_size(measurement)
      spacing_before + public_send(measurement) + spacing_after
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

    def add_image!(top_offset, left_offset)
      images << Image.new(data).tap do |image|
        image.top = top + top_offset
        image.left = left + left_offset
      end
    end
  end
end
