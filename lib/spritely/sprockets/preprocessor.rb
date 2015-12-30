require 'sprockets/directive_processor'

module Spritely
  module Sprockets
    class Preprocessor < ::Sprockets::DirectiveProcessor
      def _call(input)
        @sprite_directives = Set.new

        super.tap do
          input[:metadata][:sprite_directives] = @sprite_directives
        end
      end

      %w(repeat position spacing).each do |directive|
        define_method("process_#{directive}_directive") do |*args|
          @sprite_directives << [directive, args].flatten
        end
      end
    end
  end
end
