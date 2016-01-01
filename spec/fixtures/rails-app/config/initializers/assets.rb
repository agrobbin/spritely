# Rails 4.2 turns on asset digest in development.
# This turns them on for all Rails versions.
Rails.application.config.assets.digest = true

# Rails 5.0 doesn't currently depend on sass-rails.
# Until it does, set the Sass style to `:nested` (the default) across all Rails versions.
if Rails.application.config.respond_to?(:sass)
  Rails.application.config.sass.style = :nested
end
