require 'active_support/core_ext/hash/deep_merge'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/hash/slice'

module Spritely
  # Provides a simpler method of querying a particular image's options. Rather
  # than each `Image` needing to know how to parse the keyword arguments passed
  # into the `spritely-map` function, this simplifies and de-duplicates the
  # passed option keys.
  #
  #   $application-sprite: spritely-map("application/*.png",
  #     $arrow-repeat: true,
  #     $arrow-spacing: 10px,
  #     $another-image-position: right,
  #     $spacing: 5px
  #   );
  #
  # The options passed in above will be easily accessible via an instance of
  # this class.
  #
  #   options['arrow'] => {repeat: true, spacing: 10}
  #   options['another-image'] => {position: 'right', spacing: 5}
  class Options < Struct.new(:hash)
    GLOBAL_OPTIONS = ['spacing', 'position']

    def cache_key
      stripped_hash.to_s
    end

    def inspect
      "#<Spritely::Options global_options=#{global_options} options=#{options}>"
    end

    def [](key)
      options[key.gsub('-', '_')] || global_options
    end

    private

    def options
      @options ||= stripped_hash.except(*GLOBAL_OPTIONS).inject({}) do |h, (key, value)|
        image, _, option = key.rpartition('_')
        h[image] ||= global_options.dup
        h.deep_merge!(image => {option.to_sym => value})
      end
    end

    def global_options
      @global_options ||= stripped_hash.slice(*GLOBAL_OPTIONS).symbolize_keys!
    end

    def stripped_hash
      @stripped_hash ||= hash.inject({}) do |h, (key, sass_object)|
        h.merge!(key => sass_object.value)
      end
    end
  end
end
