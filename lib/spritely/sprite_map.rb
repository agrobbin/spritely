require 'forwardable'
require 'spritely/options'
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

    def inspect
      "#<Spritely::SpriteMap name=#{name} filename=#{filename}>"
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
      !File.exist?(filename) || outdated?
    end

    private

    def files
      Spritely.environment.paths.flat_map { |path| Dir.glob(File.join(path, glob)) }
    end

    def outdated?
      collection.last_modification_time > Spritely.modification_time(filename)
    end
  end
end
