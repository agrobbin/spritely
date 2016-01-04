require 'forwardable'
require 'digest/md5'
require 'spritely/collection'
require 'spritely/generators/chunky_png'

module Spritely
  class SpriteMap
    extend Forwardable

    def_delegators :collection, :find, :width, :height, :images

    attr_reader :name, :glob, :environment, :options

    def initialize(name, environment, options)
      @name = name
      @glob = [name, "*.png"].join("/")
      @environment = environment
      @options = options
    end

    def inspect
      "#<Spritely::SpriteMap name=#{name} options=#{options}>"
    end

    def cache_key
      @cache_key ||= Digest::MD5.hexdigest([options, collection].join)
    end

    def collection
      @collection ||= Collection.create(files, options)
    end

    def save!
      Generators::ChunkyPng.new(self).build!
    end

    def files
      environment.paths.flat_map { |path| Dir.glob(File.join(path, glob)) }.sort
    end
  end
end
