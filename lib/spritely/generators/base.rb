module Spritely
  module Generators
    class Base
      attr_reader :sprite_map

      def initialize(sprite_map)
        @sprite_map = sprite_map
      end

      def build!
        raise NotImplementedError, "#{self.class} must implement #build!"
      end
    end
  end
end
