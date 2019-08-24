require 'spritely/version'
require 'spritely/sprite_map'

module Spritely
  module Sprockets
    class Transformer
      attr_reader :input

      def self.call(input)
        new(input).call
      end

      def self.cache_key
        @cache_key ||= "#{name}:#{Spritely::VERSION}".freeze
      end

      def initialize(input)
        @input = input
      end

      def call
        data = cache.fetch([self.class.cache_key, input[:name], sprite_map.cache_key]) do
          sprite_map.files.each do |file|
            context.depend_on(File.dirname(file))
            context.link_asset(file)
          end

          sprite_map.save!
        end

        context.metadata.merge(data: data)
      end

      private

      def context
        @context ||= input[:environment].context_class.new(input)
      end

      def cache
        @cache ||= input[:cache]
      end

      def sprite_map
        @sprite_map ||= SpriteMap.new(input[:name].remove("sprites/"), input[:environment], input[:metadata][:sprite_directives])
      end
    end
  end
end
