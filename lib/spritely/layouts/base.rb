module Spritely
  module Layouts
    class Base < Struct.new(:image_sets)
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
