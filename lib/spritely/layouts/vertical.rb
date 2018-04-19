require 'spritely/layouts/base'

module Spritely
  module Layouts
    class Vertical < Spritely::Layouts::Base
      # Upon creation, the collection is then positioned appropriately by
      # positioning each image within the sprite.
      def position!
        image_sets.each_with_index(&method(:position_image_set!))
      end

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
        @height ||= heights.reduce(:+)
      end

      private

      # When positioned in the sprite, we must take into account whether the image
      # is configured to repeat, or is positioned to the opposite side of the
      # sprite map.
      def position_image_set!(image_set, index)
        image_set.top = heights[0..index].reduce(:+) - image_set.outer_size(:height)

        if image_set.repeated?
          left = 0
          while left < width
            image_set.add_image!(image_set.spacing_before, left)
            left += image_set.width
          end
        elsif image_set.opposite?
          image_set.left = width - image_set.width
          image_set.add_image!(image_set.spacing_before, 0)
        else
          image_set.add_image!(image_set.spacing_before, 0)
        end
      end

      def max_width
        @max_width ||= image_sets.collect(&:width).max
      end

      def heights
        @heights ||= image_sets.collect { |image_set| image_set.outer_size(:height) }
      end
    end
  end
end
