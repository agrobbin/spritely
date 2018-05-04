module Spritely
  module Layouts
    class ConventionalSizer
      def initialize(image_sets, fixed:, variable:)
        @image_sets = image_sets
        @fixed_size_method = fixed
        @variable_size_method = variable
      end

      def fixed_size
        @fixed_size ||= fixed_sizes.reduce(:+)
      end

      # Returns the variable size of the to-be-generated sprite image. When none of the
      # images repeat, it is simply the max variable size of all images in the sprite.
      # When an image in the sprite is repeated, a calculation is performed based
      # on the least common multiple of all repeated images. That least common
      # multiple is then multiplied by the minimum multiple that will result in a
      # value greater than or equal to the max variable size of all images in the sprite.
      def variable_size
        @variable_size ||= if image_sets.none?(&:repeated?)
          max_variable_size
        else
          lcm = image_sets.select(&:repeated?).collect(&variable_size_method).reduce(:lcm)

          lcm * (max_variable_size / lcm.to_f).ceil
        end
      end

      def fixed_offset(image_set, index)
        fixed_sizes[0..index].reduce(:+) - image_set.outer_size(fixed_size_method)
      end

      private

      attr_reader :image_sets, :fixed_size_method, :variable_size_method

      def max_variable_size
        @max_variable_size ||= image_sets.collect(&variable_size_method).max
      end

      def fixed_sizes
        @fixed_sizes ||= image_sets.collect { |image_set| image_set.outer_size(fixed_size_method) }
      end
    end
  end
end
