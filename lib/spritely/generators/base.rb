module Spritely
  module Generators
    class Base < Struct.new(:sprite_map)
      def build!
        raise NotImplementedError, "#{self.class} must implement #build!"
      end
    end
  end
end
