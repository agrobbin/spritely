require 'forwardable'
require 'digest/md5'
require 'spritely/collection'
require 'spritely/generators/chunky_png'

module Spritely
  class SpriteMap
    extend Forwardable

    def_delegators :collection, :find, :width, :height, :images

    attr_reader :name, :environment, :options, :directory, :sort, :layout, :glob

    def initialize(name, environment, options)
      @name = name
      @environment = environment
      @options = options.dup
      @directory = @options.delete(:directory) || name
      @sort = @options.delete(:sort) || ['name']
      @layout = @options.delete(:layout) || 'vertical'
      @glob = [directory, "*.png"].join("/")
    end

    def inspect
      "#<Spritely::SpriteMap name=#{name} directory=#{directory} sort=#{sort} layout=#{layout} options=#{options}>"
    end

    def cache_key
      @cache_key ||= Digest::MD5.hexdigest([options, collection].join)
    end

    def collection
      @collection ||= Collection.create(files, sort, layout, options)
    end

    def save!
      Generators::ChunkyPng.new(self).build!
    end

    def files
      environment.paths.flat_map { |path| Dir.glob(File.join(path, glob)) }
    end
  end
end
