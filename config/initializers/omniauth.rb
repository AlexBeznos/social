Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET']
  provider :instagram, ENV['INSTAGRAM_APP_ID'], ENV['INSTAGRAM_SECRET'], {:scope => 'relationships'}
end
