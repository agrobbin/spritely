require 'sprockets/manifest'
require 'active_support/core_ext/module/aliasing'

module Sprockets
  class Manifest
    def compile_with_sprites(*args)
      compile_without_sprites(*args)
      Dir.glob(Spritely.directory.join('*.png')).each(&method(:compile_without_sprites))
    end

    alias_method_chain :compile, :sprites
  end
end
