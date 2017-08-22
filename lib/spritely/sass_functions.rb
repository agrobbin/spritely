require 'sass'

module Spritely
  module SassFunctions
    def spritely_url(sprite_name)
      sprockets_context.link_asset("sprites/#{sprite_name.value}.png")

      asset_url(Sass::Script::Value::String.new("sprites/#{sprite_name.value}.png"))
    end

    ::Sass::Script::Functions.declare :spritely_url, [:sprite_name]

    def spritely_position(sprite_name, image_name)
      image = find_image(sprite_name, image_name)

      x = Sass::Script::Value::Number.new(-image.left, image.left == 0 ? [] : ['px'])
      y = Sass::Script::Value::Number.new(-image.top, image.top == 0 ? [] : ['px'])

      sass_space_separated_list([x, y])
    end

    ::Sass::Script::Functions.declare :spritely_position, [:sprite_name, :image_name]

    def spritely_background(sprite_name, image_name)
      sass_space_separated_list([spritely_url(sprite_name), spritely_position(sprite_name, image_name)])
    end

    ::Sass::Script::Functions.declare :spritely_background, [:sprite_name, :image_name]

    def spritely_width(sprite_name, image_name = nil)
      image = if image_name
        find_image(sprite_name, image_name)
      else
        find_sprite_map(sprite_name)
      end

      Sass::Script::Value::Number.new(image.width, ['px'])
    end

    ::Sass::Script::Functions.declare :spritely_width, [:sprite_name, :image_name]

    def spritely_height(sprite_name, image_name = nil)
      image = if image_name
        find_image(sprite_name, image_name)
      else
        find_sprite_map(sprite_name)
      end

      Sass::Script::Value::Number.new(image.height, ['px'])
    end

    ::Sass::Script::Functions.declare :spritely_height, [:sprite_name, :image_name]

    private

    def find_image(sprite_name, image_name)
      sprite_map = find_sprite_map(sprite_name)

      sprite_map.find(image_name.value) || raise(Sass::SyntaxError, "No image '#{image_name.value}' found in sprite map '#{sprite_map.name}'.")
    end

    def find_sprite_map(sprite_name)
      sprockets_context.link_asset("sprites/#{sprite_name.value}.png")

      sprite_maps.fetch(sprite_name.value) do |name|
        asset = sprockets_environment.find_asset("sprites/#{name}.png.sprite") || raise(Sass::SyntaxError, "No sprite map '#{name}' found.")

        sprite_maps[name] = SpriteMap.new(name, sprockets_environment, asset.metadata[:sprite_directives])
      end
    end

    def sprite_maps
      @sprite_maps ||= {}
    end

    def sass_space_separated_list(value)
      # Sass 3.5 introduced support for bracketed lists (sass/sass@be02da0), which changed the
      # method signature of `Sass::Script::Value::List#initialize` to accept the `separator` as a
      # keyword argument rather than as the second positional argument.
      if Gem::Version.new(Sass.version[:number]) < Gem::Version.new("3.5")
        Sass::Script::Value::List.new(value, :space)
      else
        Sass::Script::Value::List.new(value, separator: :space)
      end
    end
  end
end

::Sass::Script::Functions.send(:include, Spritely::SassFunctions)
