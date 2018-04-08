require 'sprockets/directive_processor'

module Spritely
  module Sprockets
    # Converts Sprockets directives from this:
    #
    #   //= directory foo/bar
    #   //= repeat arrow true
    #   //= spacing-below arrow 10
    #   //= position another-image right
    #   //= spacing-above 5
    #   //= spacing-below 5
    #
    # To this:
    #
    #   {
    #     directory: 'foo/bar',
    #     global: { spacing_above: '5', spacing_below: '5' },
    #     images: {
    #       'arrow' => { repeat: 'true', spacing_above: '10', spacing_below: '5' },
    #       'another-image' => { position: 'right', spacing_above: '5', spacing_below: '5' }
    #     }
    #   }
    class Preprocessor < ::Sprockets::DirectiveProcessor
      GLOBAL_DIRECTIVES = %w(position spacing spacing-above spacing-below).freeze
      IMAGE_DIRECTIVES = %w(repeat position spacing spacing-above spacing-below).freeze

      def _call(input)
        @sprite_directives = { directory: nil, global: {}, images: {} }

        super.tap do
          merge_global_options!

          input[:metadata][:sprite_directives] = @sprite_directives
        end
      end

      def process_directory_directive(value)
        @sprite_directives[:directory] = value
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
        check_if_deprecated_directive(directive)

        @sprite_directives[:images][image] ||= {}
        @sprite_directives[:images][image][directive.tr('-', '_').to_sym] = value
      end

      def process_global_option(directive, value)
        raise ArgumentError, "'#{directive}' is not a valid global option" unless GLOBAL_DIRECTIVES.include?(directive)

        check_if_deprecated_directive(directive)

        @sprite_directives[:global][directive.tr('-', '_').to_sym] = value
      end

      def merge_global_options!
        @sprite_directives[:images].each do |image, options|
          options.merge!(@sprite_directives[:global]) { |key, left, right| left }
        end
      end

      def check_if_deprecated_directive(directive)
        if directive == 'spacing'
          Spritely.logger.warn "The `spacing` directive is deprecated and has been replaced by `spacing-below`. It will be removed in Spritely 3.0. (called from #{@filename})"
        end
      end
    end
  end
end
