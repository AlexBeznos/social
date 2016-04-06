require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Social
  class Application < Rails::Application
    config.autoload_paths += %w( "#{config.root}/app/services" "#{config.root}/app/decorators" "#{config.root}/app/validators" "#{config.root}/app/workers")
    config.eager_load_paths += %w( "#{config.root}/app/services" "#{config.root}/app/decorators" "#{config.root}/app/validators" "#{config.root}/app/workers")

    Rails.application.config.assets.precompile += %w( *.css )
    Rails.application.config.assets.precompile += %w( *.js )
    config.assets.precompile << /\.(?:svg|eot|woff|woff2|ttf|jpg|png|ico|gif)\z/

    # localization
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}').to_s]
    config.i18n.default_locale = :ru

    config.i18n.available_locales = [:en, :ru, :ua, :am, :pl, :hu]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.middleware.use Rack::Deflater
    config.middleware.use Rack::Attack
    config.time_zone = 'Kyiv'
  end
end
