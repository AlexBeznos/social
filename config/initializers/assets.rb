# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(dashboard/statistic.css bootstrap.css gowifi.css gowifi_previews.css loyalty.css code_highlight.css landing_new.css landing_old.css)
Rails.application.config.assets.precompile += %w(sms-auth.js gowifi.js dashboard/*.js landing_new.js landing_old.js code_highlight.js)

Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|woff2|ttf|jpg|png|ico|gif)\z/
