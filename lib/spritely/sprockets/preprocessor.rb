require 'sprockets/directive_processor'

module Spritely
  module Sprockets
    # Converts Sprockets directives from this:
    #
    #   //= repeat arrow true
    #   //= spacing arrow 10
    #   //= position another-image right
    #   //= spacing 5
    #
    # To this:
    #
    #   {
    #     global: { spacing: 5 },
    #     images: {
    #       'arrow' => { repeat: 'true', spacing: '10' },
    #       'another-image' => { position: 'right', spacing: '5' }
    #     }
    #   }
    class Preprocessor < ::Sprockets::DirectiveProcessor
      GLOBAL_DIRECTIVES = %w(position spacing).freeze
      IMAGE_DIRECTIVES = %w(repeat position spacing).freeze

      def _call(input)
        @sprite_directives = { global: {}, images: {} }

        super.tap do
          merge_global_options!

          input[:metadata][:sprite_directives] = @sprite_directives
        end
      end

      (GLOBAL_DIRECTIVES + IMAGE_DIRECTIVES).uniq.each do |directive|
        define_method("process_#{directive}_directive") do |image_or_value, value_or_nil = nil|
          if value_or_nil
            process_image_option(directive, image_or_value, value_or_nil)
          else
            process_global_option(directive, image_or_value)
          end
        end
      end

      private

      def process_image_option(directive, image, value)
        @sprite_directives[:images][image] ||= {}
        @sprite_directives[:images][image][directive.to_sym] = value
      end

      def process_global_option(directive, value)
        raise ArgumentError, "'#{directive}' is not a valid global option" unless GLOBAL_DIRECTIVES.include?(directive)

        @sprite_directives[:global][directive.to_sym] = value
      end

      def merge_global_options!
        @sprite_directives[:images].each do |image, options|
          options.merge!(@sprite_directives[:global]) { |key, left, right| left }
        end
      end
    end
  end
end
