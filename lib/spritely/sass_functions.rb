require 'sass'

module Spritely
  module SassFunctions
    def spritely_url(sprite_name)
      sprockets_context.link_asset("sprites/#{sprite_name.value}.png")

      asset_url(Sass::Script::String.new("sprites/#{sprite_name.value}.png"))
    end

    ::Sass::Script::Functions.declare :spritely_url, [:sprite_name]

    def spritely_position(sprite_name, image_name)
      image = find_image(sprite_name, image_name)

      x = Sass::Script::Number.new(-image.left, image.left == 0 ? [] : ['px'])
      y = Sass::Script::Number.new(-image.top, image.top == 0 ? [] : ['px'])

      Sass::Script::List.new([x, y], :space)
    end

    ::Sass::Script::Functions.declare :spritely_position, [:sprite_name, :image_name]

    def spritely_background(sprite_name, image_name)
      Sass::Script::List.new([spritely_url(sprite_name), spritely_position(sprite_name, image_name)], :space)
    end

    ::Sass::Script::Functions.declare :spritely_background, [:sprite_name, :image_name]

    def spritely_width(sprite_name, image_name = nil)
      image = if image_name
        find_image(sprite_name, image_name)
      else
        find_sprite_map(sprite_name)
      end

      Sass::Script::Number.new(image.width, ['px'])
    end

    ::Sass::Script::Functions.declare :spritely_width, [:sprite_name, :image_name]

    def spritely_height(sprite_name, image_name = nil)
      image = if image_name
        find_image(sprite_name, image_name)
      else
        find_sprite_map(sprite_name)
      end

      Sass::Script::Number.new(image.height, ['px'])
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
  end
end

::Sass::Script::Functions.send(:include, Spritely::SassFunctions)
