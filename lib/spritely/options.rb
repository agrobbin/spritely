require 'active_support/core_ext/hash/deep_merge'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/hash/slice'

module Spritely
  class Options < Struct.new(:hash)
    GLOBAL_OPTIONS = [:spacing]

    def cache_key
      stripped_hash.to_s
    end

    def [](key)
      options[key] || global_options
    end

    private

    def options
      @options ||= stripped_hash.except(*GLOBAL_OPTIONS).inject({}) do |h, (key, value)|
        split_key = key.to_s.split('_')
        option = global_options.merge(split_key.pop.to_sym => value)
        h.deep_merge!(split_key.join('-') => option)
      end
    end

    def global_options
      @global_options ||= stripped_hash.slice(*GLOBAL_OPTIONS)
    end

    def stripped_hash
      @stripped_hash ||= hash.inject({}) do |h, (key, sass_object)|
        h.merge!(key.to_sym => sass_object.value)
      end
    end
  end
end
