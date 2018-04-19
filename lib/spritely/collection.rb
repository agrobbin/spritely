require 'spritely/image_set'
require 'spritely/layouts/horizontal'
require 'spritely/layouts/vertical'

module Spritely
  # A `SpriteMap` has a `Collection` that knows how to calculate the size of the
  # sprite, based on direction, image repetition, and spacing.
  class Collection < Struct.new(:files, :sort_options, :layout_key, :options)
    extend Forwardable

    def_delegators :layout, :width, :height, :position!

    LAYOUTS = {
      horizontal: Layouts::Horizontal,
      vertical: Layouts::Vertical
    }.freeze

    def self.create(*args)
      new(*args).tap do |collection|
        collection.sort!
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
      files.flat_map { |file_path| [Digest::MD5.hexdigest(file_path), Digest::MD5.file(file_path)] }.join
    end
    alias_method :to_s, :cache_key

    def sort!
      attribute, direction = sort_options

      image_sets.sort_by!(&attribute.to_sym)
      image_sets.reverse! if direction == 'desc'
    end

    private

    def image_sets
      @image_sets ||= files.collect { |file| ImageSet.new(file, options[:images][File.basename(file, ".png")] || options[:global]) }
    end

    def layout
      @layout ||= layout_class.new(image_sets)
    end

    def layout_class
      LAYOUTS[layout_key.to_sym] || raise(ArgumentError, "Unknown `layout`: #{layout_key}")
    end
  end
end
