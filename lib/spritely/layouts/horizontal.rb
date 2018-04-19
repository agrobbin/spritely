require 'spritely/layouts/base'
require 'spritely/layouts/conventional_sizer'

module Spritely
  module Layouts
    class Horizontal < Spritely::Layouts::Base
      def position!
        image_sets.each_with_index(&method(:position_image_set!))
      end

      def width
        @width ||= sizer.fixed_size
      end

      def height
        @height ||= sizer.variable_size
      end

      private

      # When positioned in the sprite, we must take into account whether the image
      # is configured to repeat, or is positioned to the opposite side of the
      # sprite map.
      def position_image_set!(image_set, index)
        image_set.left = sizer.fixed_offset(image_set, index)

        if image_set.repeated?
          top = 0
          while top < height
            image_set.add_image!(top, image_set.spacing_before)
            top += image_set.height
          end
        elsif image_set.opposite?
          image_set.top = height - image_set.height
          image_set.add_image!(0, image_set.spacing_before)
        else
          image_set.add_image!(0, image_set.spacing_before)
        end
      end

      def sizer
        @sizer ||= ConventionalSizer.new(image_sets, fixed: :width, variable: :height)
      end
    end
  end
end
