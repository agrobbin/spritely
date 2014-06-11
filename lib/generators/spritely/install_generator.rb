require 'rails/generators/base'

module Spritely
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      def add_sprites_folder_to_gitignore
        create_file '.gitignore', skip: true
        inject_into_file '.gitignore', "\n#{Spritely.relative_folder_path}\n", after: /\z/
      end
    end
  end
end
