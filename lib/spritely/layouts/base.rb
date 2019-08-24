module Spritely
  module Layouts
    class Base
      attr_reader :image_sets

      def initialize(image_sets)
        @image_sets = image_sets
      end

      def position!
        raise NotImplementedError, "#{self.class} must implement #position!"
      end

      def width
        raise NotImplementedError, "#{self.class} must implement #width"
      end

      def height
        raise NotImplementedError, "#{self.class} must implement #height"
      end
    end
  end
end
