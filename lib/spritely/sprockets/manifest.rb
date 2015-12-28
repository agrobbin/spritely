require 'sprockets/manifest'

module Spritely
  # In order to hook into Sprockets' asset compilation appropriately, we must
  # chain our own implementation of `compile`. Our extension calls up to the
  # original, and then performs the same action on the generated sprite images,
  # forcing the sprites to be part of the compiled asset manifest.
  module Sprockets
    module Manifest
      def compile(*args)
        super
        super(*Dir.glob(Spritely.directory.join('*.png')))
      end
    end

    # TODO: Once we drop support for Ruby 2.0, stop using `send`.
    # `Module#prepend` was made public in Ruby 2.1.
    ::Sprockets::Manifest.send(:prepend, Manifest)
  end
end
