require 'forwardable'
require 'digest/md5'
require 'spritely/options'
require 'spritely/collection'
require 'spritely/generators/chunky_png'

module Spritely
  class SpriteMap
    extend Forwardable

    def_delegators :collection, :find, :width, :height, :images

    attr_reader :name, :glob, :environment, :options

    def initialize(name, environment, directives)
      @name = name
      @glob = [name, "*.png"].join("/")
      @environment = environment
      @options = Options.new(directives)
    end

    def inspect
      "#<Spritely::SpriteMap name=#{name} options=#{options}>"
    end

    def cache_key
      @cache_key ||= Digest::MD5.hexdigest([options, collection].collect(&:cache_key).join)
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
