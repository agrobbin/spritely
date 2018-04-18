require 'sprockets/directive_processor'

module Spritely
  module Sprockets
    # Converts Sprockets directives from this:
    #
    #   //= directory foo/bar
    #   //= sort name desc
    #   //= repeat arrow true
    #   //= spacing_after arrow 10
    #   //= opposite another-image true
    #   //= spacing_before 5
    #   //= spacing_after 5
    #
    # To this:
    #
    #   {
    #     directory: 'foo/bar',
    #     sort: ['name, 'desc'],
    #     global: { spacing_before: '5', spacing_after: '5' },
    #     images: {
    #       'arrow' => { repeat: 'true', spacing_before: '10', spacing_after: '5' },
    #       'another-image' => { opposite: 'true', spacing_before: '5', spacing_after: '5' }
    #     }
    #   }
    class Preprocessor < ::Sprockets::DirectiveProcessor
      IMAGE_DIRECTIVES = %w(repeat opposite spacing_before spacing_after).freeze

      def _call(input)
        @sprite_directives = { directory: nil, sort: nil, global: {}, images: {} }

        super.tap do
          merge_global_options!

          input[:metadata][:sprite_directives] = @sprite_directives
        end
      end

      def process_directory_directive(value)
        @sprite_directives[:directory] = value
      end

      def process_sort_directive(*values)
        @sprite_directives[:sort] = values
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

      def process_position_directive(image_or_value, value_or_nil = nil)
        Spritely.logger.warn "The `position` directive is deprecated and has been replaced by `opposite`. It will be removed in Spritely 3.0. (called from #{@filename})"

        if value_or_nil
          process_opposite_directive(image_or_value, 'true')
        else
          process_opposite_directive('true')
        end
      end

      def process_spacing_directive(*args)
        Spritely.logger.warn "The `spacing` directive is deprecated and has been replaced by `spacing_after`. It will be removed in Spritely 3.0. (called from #{@filename})"

        process_spacing_after_directive(*args)
      end

      def process_spacing_above_directive(*args)
        Spritely.logger.warn "The `spacing_above` directive is deprecated and has been replaced by `spacing_before`. It will be removed in Spritely 3.0. (called from #{@filename})"

        process_spacing_before_directive(*args)
      end

      # Use `define_method` here because of the dash in the directive name
      define_method("process_spacing-above_directive") do |*args|
        Spritely.logger.warn "The `spacing-above` directive is deprecated and has been replaced by `spacing_before`. It will be removed in Spritely 3.0. (called from #{@filename})"

        process_spacing_before_directive(*args)
      end

      def process_spacing_below_directive(*args)
        Spritely.logger.warn "The `spacing_below` directive is deprecated and has been replaced by `spacing_after`. It will be removed in Spritely 3.0. (called from #{@filename})"

        process_spacing_after_directive(*args)
      end

      # Use `define_method` here because of the dash in the directive name
      define_method("process_spacing-below_directive") do |*args|
        Spritely.logger.warn "The `spacing-below` directive is deprecated and has been replaced by `spacing_after`. It will be removed in Spritely 3.0. (called from #{@filename})"

        process_spacing_after_directive(*args)
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
