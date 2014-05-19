require 'spritely/sprite_map'

module Spritely
  module SassFunctions
    def sprite_map(glob, kwargs = {})
      SpriteMap.create(glob, kwargs)
    end

    ::Sass::Script::Functions.declare :sprite_map, [:glob], var_kwargs: true

    def sprite_url(sprite_map)
      asset_url(Sass::Script::String.new("sprites/#{sprite_map.name}.png"))
    end

    ::Sass::Script::Functions.declare :sprite_url, [:sprite_map]

    def sprite_position(sprite_map, image_name)
      image = sprite_map.find(image_name.value)

      x = Sass::Script::Number.new(image.left, image.left == 0 ? [] : ['px'])
      y = Sass::Script::Number.new(-image.top, image.top == 0 ? [] : ['px'])

      Sass::Script::List.new([x, y], :space)
    end

    ::Sass::Script::Functions.declare :sprite_position, [:sprite_map, :image_name]

    def sprite_width(sprite_map, image_name)
      image = sprite_map.find(image_name.value)

      Sass::Script::Number.new(image.width, ['px'])
    end

    ::Sass::Script::Functions.declare :sprite_width, [:sprite_map, :image_name]

    def sprite_height(sprite_map, image_name)
      image = sprite_map.find(image_name.value)

      Sass::Script::Number.new(image.height, ['px'])
    end

    ::Sass::Script::Functions.declare :sprite_height, [:sprite_map, :image_name]
  end
end

::Sass::Script::Functions.send(:include, Spritely::SassFunctions)
