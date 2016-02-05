require 'spritely/image_set'

module Spritely
  # A `SpriteMap` has a `Collection` that knows how to calculate the size of the
  # sprite, based on image repetition and spacing.
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
      files.collect { |file| Digest::MD5.file(file) }.join
    end
    alias_method :to_s, :cache_key

    # Returns the width of the to-be-generated sprite image. When none of the
    # images repeat, it is simply the max width of all images in the sprite.
    # When an image in the sprite is repeated, a calculation is performed based
    # on the least common multiple of all repeated images. That least common
    # multiple is then multiplied by the minimum multiple that will result in a
    # value greater than or equal to the max width of all images in the sprite.
    def width
      @width ||= if image_sets.none?(&:repeated?)
        max_width
      else
        lcm = image_sets.select(&:repeated?).collect(&:width).reduce(:lcm)

        lcm * (max_width / lcm.to_f).ceil
      end
    end

    def height
      heights.reduce(:+)
    end

    # Upon creation, the collection is then positioned appropriately by
    # positioning each image within the sprite.
    def position!
      image_sets.each_with_index do |image_set, index|
        image_set.top = heights[0..index].reduce(:+) - image_set.outer_height
        image_set.position_in!(width)
      end
    end

    private

    def image_sets
      @image_sets ||= files.collect { |file| ImageSet.new(file, options[:images][File.basename(file, ".png")] || options[:global]) }
    end

    def max_width
      @max_width ||= image_sets.collect(&:width).max
    end

    def heights
      @heights ||= image_sets.collect(&:outer_height)
    end
  end
end
