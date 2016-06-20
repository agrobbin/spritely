require 'forwardable'
require 'digest/md5'
require 'spritely/collection'
require 'spritely/generators/chunky_png'

module Spritely
  class SpriteMap
    extend Forwardable

    def_delegators :collection, :find, :width, :height, :images

    attr_reader :name, :environment, :options, :directory, :glob

    def initialize(name, environment, options)
      @name = name
      @environment = environment
      @options = options.dup
      @directory = @options.delete(:directory) || name
      @glob = [directory, "*.png"].join("/")
    end

    def inspect
      "#<Spritely::SpriteMap name=#{name} directory=#{directory} options=#{options}>"
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
