require 'spritely/generators/base'
require 'chunky_png'

module Spritely
  module Generators
    class ChunkyPng < Spritely::Generators::Base
      def build!
        sprite_map.images.each do |image|
          png = ::ChunkyPNG::Image.from_blob(image.data)
          canvas.replace!(png, image.left, image.top)
        end
      end

      def save!
        canvas.metadata['cache_key'] = sprite_map.cache_key
        canvas.save(sprite_map.filename, :fast_rgba)
      end

      private

      def canvas
        @canvas ||= ::ChunkyPNG::Image.new(sprite_map.width, sprite_map.height)
      end
    end
  end
end
