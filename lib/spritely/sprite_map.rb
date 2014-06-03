require 'forwardable'
require 'spritely/options'
require 'spritely/cache'
require 'spritely/collection'
require 'spritely/generators/chunky_png'

module Spritely
  class SpriteMap < Sass::Script::Literal
    extend Forwardable

    def_delegators :collection, :find, :width, :height, :images

    attr_reader :glob, :options

    def self.create(*args)
      new(*args).tap do |sprite_map|
        sprite_map.generate! if sprite_map.needs_generation?
      end
    end

    def initialize(glob, options = {})
      @glob = glob
      @options = Options.new(options)
    end

    def cache_key
      @cache_key ||= Cache.generate(options, collection)
    end

    def inspect
      "#<Spritely::SpriteMap name=#{name} options=#{options}>"
    end

    def collection
      @collection ||= Collection.create(files, options)
    end

    def generate!
      Generators::ChunkyPng.create!(self)
    end

    def name
      glob.split('/')[0..-2].join('-')
    end

    def filename
      Spritely.directory.join("#{name}.png")
    end

    def needs_generation?
      !File.exist?(filename) || Cache.busted?(filename, cache_key)
    end

    def files
      Spritely.environment.paths.flat_map { |path| Dir.glob(File.join(path, glob)) }
    end
  end
end
