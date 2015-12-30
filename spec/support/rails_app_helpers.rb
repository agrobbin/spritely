module RailsAppHelpers
  GENERATOR_FLAGS = [
    '--skip-active-record',
    '--skip-test-unit',
    '--skip-javascript',
    '--skip-spring',
    '--skip-bundle'
  ]

  def within_rails_app(&block)
    Dir.mktmpdir do |tmpdir|
      Dir.chdir(tmpdir) do
        flags = GENERATOR_FLAGS
        flags << '--edge' if ENV['BUNDLE_GEMFILE'] =~ /rails_edge\.gemfile$/
        %x(rails new dummy #{flags.join(' ')})
        Dir.chdir('dummy') do
          Bundler.with_clean_env do
            File.open('Gemfile', 'a') do |f|
              f.write("gem 'spritely', path: '#{__dir__}/../../'\n")
              f.write("gem 'sprockets-rails', '#{Sprockets::Rails::VERSION}'\n")
              f.write("gem 'sprockets', '#{Sprockets::VERSION}'")
            end
            %x(bundle install)
            %x(rails generate spritely:install)
            FileUtils.cp_r "#{__dir__}/../fixtures/rails-app/.", "."
            yield
          end
        end
      end
    end
  end

  def render_asset(filename)
    runner "puts Rails.application.assets[#{filename.inspect}]"
  end

  def spite_image_path(sprite_name)
    fingerprint = runner(%~puts Rails.application.assets["sprites/#{sprite_name}.png"].hexdigest~)
    "/assets/sprites/application-#{fingerprint.strip}.png"
  end

  def compile_assets
    %x(RAILS_ENV=production rake assets:precompile)
  end

  private

  def runner(command)
    %x(rails runner -e development '#{command}')
  end
end
