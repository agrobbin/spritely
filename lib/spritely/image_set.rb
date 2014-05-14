require 'spritely/image'

module Spritely
  class ImageSet
    extend Forwardable

    def_delegator :@images, :each

    attr_reader :files, :images

    def initialize(files)
      @files = files
      @images = files.collect { |file| Image.new(file) }.sort_by(&:width).reverse
      position!
    end

    def find(name)
      images.find { |image| image.name == name }
    end

    def max_width
      @max_width ||= images.collect(&:width).max
    end

    def total_height
      @total_height ||= images.collect(&:height).reduce(:+)
    end

    def last_modification_time
      files.collect { |file| Spritely.modification_time(file) }.max
    end

    private

    def position!
      images.each_with_index do |image, index|
        image.top = images.collect(&:height)[0..index].reduce(:+) - image.height
      end
    end
  end
end
