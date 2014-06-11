require 'rails/generators/base'

module Spritely
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      def create_empty_sprites_folder
        empty_directory Spritely.relative_folder_path
        create_file "#{Spritely.relative_folder_path}/.keep"
      end

      def add_sprites_folder_to_gitignore
        create_file '.gitignore', skip: true
        inject_into_file '.gitignore', "\n/#{Spritely.relative_folder_path.join('*.png')}\n", after: /\z/
      end
    end
  end
end
