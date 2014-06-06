require 'sprockets/manifest'
require 'active_support/core_ext/module/aliasing'

module Sprockets
  # In order to hook into Sprockets' asset compilation appropriately, we must
  # chain our own implementation of `compile`. Our extension calls up to the
  # original, and then performs the same action on the generated sprite images,
  # forcing the sprites to be part of the compiled asset manifest.
  class Manifest
    def compile_with_sprites(*args)
      compile_without_sprites(*args)
      Dir.glob(Spritely.directory.join('*.png')).each(&method(:compile_without_sprites))
    end

    alias_method_chain :compile, :sprites
  end
end
