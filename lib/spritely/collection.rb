require 'spritely/image_set'

module Spritely
  class Collection < Struct.new(:files, :options)
    def self.create(*args)
      new(*args).tap do |collection|
        collection.position!
      end
    end

    def images
      image_sets.flat_map(&:images)
    end

    def find(name)
      image_sets.find { |image_set| image_set.name == name }
    end

    def cache_key
      files.collect { |file| File.mtime(file) }.join
    end

    def width
      return @width if @width

      max_width = image_sets.collect(&:width).max
      if image_sets.none?(&:repeated?)
        @width = max_width
      else
        @width = lcm = image_sets.select(&:repeated?).collect(&:width).reduce(:lcm)
        @width += lcm while @width < max_width
      end

      @width
    end

    def height
      heights.reduce(:+)
    end

    def position!
      image_sets.each_with_index do |image_set, index|
        image_set.top = heights[0..index].reduce(:+) - image_set.outer_height
        image_set.position_in!(width)
      end
    end

    private

    def image_sets
      @image_sets ||= files.collect { |file| ImageSet.new(file, options[File.basename(file, ".png")]) }.sort_by(&:width).reverse
    end

    def heights
      image_sets.collect(&:outer_height)
    end
  end
end
