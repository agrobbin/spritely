require 'spritely/sprite_map'

module Spritely
  module SassFunctions
    def spritely_map(glob, kwargs = {})
      SpriteMap.create(glob.value, kwargs).tap do |sprite_map|
        Spritely.sprockets_adapter.reset_cache!(sprockets_environment, sprite_map.filename)
        sprockets_context.depend_on(Spritely.directory)
        sprite_map.files.each do |file|
          sprockets_context.depend_on(file)
          sprockets_context.depend_on_asset(file)
        end
      end
    end

    ::Sass::Script::Functions.declare :spritely_map, [:glob], var_kwargs: true

    def spritely_url(sprite_map)
      asset_url(Sass::Script::String.new("sprites/#{sprite_map.name}.png"))
    end

    ::Sass::Script::Functions.declare :spritely_url, [:sprite_map]

    def spritely_position(sprite_map, image_name)
      image = find_image(sprite_map, image_name)

      x = Sass::Script::Number.new(-image.left, image.left == 0 ? [] : ['px'])
      y = Sass::Script::Number.new(-image.top, image.top == 0 ? [] : ['px'])

      Sass::Script::List.new([x, y], :space)
    end

    ::Sass::Script::Functions.declare :spritely_position, [:sprite_map, :image_name]

    def spritely_background(sprite_map, image_name)
      Sass::Script::List.new([spritely_url(sprite_map), spritely_position(sprite_map, image_name)], :space)
    end

    ::Sass::Script::Functions.declare :spritely_background, [:sprite_map, :image_name]

    def spritely_width(sprite_map, image_name)
      image = find_image(sprite_map, image_name)

      Sass::Script::Number.new(image.width, ['px'])
    end

    ::Sass::Script::Functions.declare :spritely_width, [:sprite_map, :image_name]

    def spritely_height(sprite_map, image_name)
      image = find_image(sprite_map, image_name)

      Sass::Script::Number.new(image.height, ['px'])
    end

    ::Sass::Script::Functions.declare :spritely_height, [:sprite_map, :image_name]

    private

    def find_image(sprite_map, image_name)
      sprite_map.find(image_name.value) || raise(Sass::SyntaxError, "No image '#{image_name.value}' found in sprite map '#{sprite_map.name}'.")
    end
  end
end

::Sass::Script::Functions.send(:include, Spritely::SassFunctions)
