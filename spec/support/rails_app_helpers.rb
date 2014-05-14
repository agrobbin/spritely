module RailsAppHelpers
  def within_rails_app(&block)
    Dir.mktmpdir do |tmpdir|
      Dir.chdir(tmpdir) do
        %x(rails new dummy --skip-active-record --skip-test-unit --skip-javascript --skip-spring --skip-git)
        Dir.chdir('dummy') do
          Bundler.with_clean_env do
            File.open('Gemfile', 'a') do |f|
              f.write("gem 'spritely', path: '#{__dir__}/../../'\n")
            end
            %x(bundle install)
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

  def compile_assets
    %x(RAILS_ENV=production rake assets:precompile)
  end

  private

  def runner(command)
    %x(rails runner -e development '#{command}')
  end
end
