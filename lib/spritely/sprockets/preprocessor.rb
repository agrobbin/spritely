require 'sprockets/directive_processor'

module Spritely
  module Sprockets
    # Converts Sprockets directives from this:
    #
    #   //= directory foo/bar
    #   //= repeat arrow true
    #   //= spacing_below arrow 10
    #   //= position another-image right
    #   //= spacing_above 5
    #   //= spacing_below 5
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
      CONFIG_DIRECTIVES = %w(directory).freeze
      IMAGE_DIRECTIVES = %w(repeat position spacing_above spacing_below).freeze

      def _call(input)
        @sprite_directives = { directory: nil, global: {}, images: {} }

        super.tap do
          merge_global_options!

          input[:metadata][:sprite_directives] = @sprite_directives
        end
      end

      CONFIG_DIRECTIVES.each do |directive|
        define_method("process_#{directive}_directive") do |value|
          @sprite_directives[directive.to_sym] = value
        end
      end

      IMAGE_DIRECTIVES.each do |directive|
        define_method("process_#{directive}_directive") do |image_or_value, value_or_nil = nil|
          if value_or_nil
            process_image_option(directive, image_or_value, value_or_nil)
          else
            process_global_option(directive, image_or_value)
          end
        end
      end

      def process_spacing_directive(*args)
        Spritely.logger.warn "The `spacing` directive is deprecated and has been replaced by `spacing_below`. It will be removed in Spritely 3.0. (called from #{@filename})"

        process_spacing_below_directive(*args)
      end

      # Use `define_method` here because of the dash in the directive name
      define_method("process_spacing-above_directive") do |*args|
        Spritely.logger.warn "The `spacing-above` directive is deprecated and has been replaced by `spacing_above`. It will be removed in Spritely 3.0. (called from #{@filename})"

        process_spacing_above_directive(*args)
      end

      # Use `define_method` here because of the dash in the directive name
      define_method("process_spacing-below_directive") do |*args|
        Spritely.logger.warn "The `spacing-below` directive is deprecated and has been replaced by `spacing_below`. It will be removed in Spritely 3.0. (called from #{@filename})"

        process_spacing_below_directive(*args)
      end

      private

      def process_image_option(directive, image, value)
        @sprite_directives[:images][image] ||= {}
        @sprite_directives[:images][image][directive.to_sym] = value
      end

      def process_global_option(directive, value)
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
