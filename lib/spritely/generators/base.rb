module Spritely
  module Generators
    class Base < Struct.new(:sprite_map)
      def self.create!(sprite_map)
        new(sprite_map).tap do |generator|
          generator.build!
          generator.ensure_directory_exists!
          generator.save!
        end
      end

      def ensure_directory_exists!
        raise("'#{Spritely.relative_folder_path}' doesn't exist. Run `rails generate spritely:install`.") unless File.exist?(Spritely.directory)
      end

      def build!
        raise NotImplementedError, "#{self.class} must implement #build!"
      end

      def save!
        raise NotImplementedError, "#{self.class} must implement #save!"
      end
    end
  end
end
