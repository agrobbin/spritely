require 'spritely/layouts/base'

module Spritely
  module Layouts
    class Vertical < Spritely::Layouts::Base
      def position!
        image_sets.each_with_index(&method(:position_image_set!))
      end

      def width
        @width ||= sizer.variable_size
      end

      def height
        @height ||= sizer.fixed_size
      end

      private

      # When positioned in the sprite, we must take into account whether the image
      # is configured to repeat, or is positioned to the opposite side of the
      # sprite map.
      def position_image_set!(image_set, index)
        image_set.top = sizer.fixed_offset(image_set, index)

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

      def sizer
        @sizer ||= ConventionalSizer.new(image_sets, fixed: :height, variable: :width)
      end
    end
  end
end
