require 'active_support/core_ext/hash/deep_merge'

module Spritely
  class Options
    attr_reader :options

    def initialize(hash)
      @options = hash.inject({}) do |h, (key, sass_object)|
        split_key = key.split('_')
        option = {split_key.pop.to_sym => sass_object.value}
        h.deep_merge!(split_key.join('-') => option)
      end
    end

    def [](key)
      options[key] || {}
    end
  end
end
