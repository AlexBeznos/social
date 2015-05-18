Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET']
  provider :instagram, ENV['INSTAGRAM_APP_ID'], ENV['INSTAGRAM_SECRET'], {:scope => 'relationships'}
  provider :vkontakte, ENV['VK_APP_ID'], ENV['VK_APP_SECRET'],
   {
     :scope => 'wall,friends',
     :display => 'page',
     :lang => 'ru',
     :image_size => 'original'
   }
end