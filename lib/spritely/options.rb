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
  #   //= repeat arrow true
  #   //= spacing arrow 10
  #   //= position another-image right
  #   //= spacing 5
  #
  # The directives passed in above will be easily accessible via an instance of
  # this class.
  #
  #   options['arrow'] => {repeat: true, spacing: 10}
  #   options['another-image'] => {position: 'right', spacing: 5}
  class Options < Struct.new(:set)
    GLOBAL_OPTIONS = ['spacing', 'position']

    def cache_key
      formatted_set.to_s
    end

    def inspect
      "#<Spritely::Options global_options=#{global_options} options=#{options}>"
    end

    alias_method :to_s, :inspect

    def [](key)
      options[key] || global_options
    end

    private

    def options
      @options ||= formatted_set.except(*GLOBAL_OPTIONS).inject({}) do |h, (key, value)|
        image, option = key.split('_')
        h[image] ||= global_options.dup
        h.deep_merge!(image => {option.to_sym => value})
      end
    end

    def global_options
      @global_options ||= formatted_set.slice(*GLOBAL_OPTIONS).symbolize_keys!
    end

    def formatted_set
      @formatted_set ||= set.inject({}) do |h, (option, image_or_value, value_or_nil)|
        value = value_or_nil || image_or_value

        h.merge!((value_or_nil ? "#{image_or_value}_#{option}" : option) => value)
      end
    end
  end
end
