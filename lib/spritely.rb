require 'sprockets'
require 'spritely/sass_functions'
require 'spritely/sprockets/preprocessor'
require 'spritely/sprockets/transformer'

module Spritely
end

::Sprockets.register_mime_type 'text/sprite', extensions: ['.png.sprite']
::Sprockets.register_preprocessor 'text/sprite', Spritely::Sprockets::Preprocessor.new(comments: ["//", ["/*", "*/"]])
::Sprockets.register_transformer 'text/sprite', 'image/png', Spritely::Sprockets::Transformer
