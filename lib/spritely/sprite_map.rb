require 'spritely/images_set'
require 'spritely/generators/chunky_png'

module Spritely
  class SpriteMap
    attr_accessor :options # Sass expects an object returned from a script function to have an #options accessor
    attr_reader :glob

    def self.create(*args)
      new(*args).tap do |sprite_map|
        sprite_map.generate! if sprite_map.needs_generation?
      end
    end

    def initialize(glob)
      @glob = glob.value
    end

    def images
      @images ||= ImagesSet.new(files)
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
      images.last_modification_time > modification_time
    end

    def modification_time
      Spritely.modification_time(filename)
    end
  end
end
