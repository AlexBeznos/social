dev_keys = %w(
  VK_APP_ID
  VK_APP_SECRET
  VK_REDIRECT_PATH
  FB_APP_ID
  FB_APP_SECRET
  TWITTER_API_KEY
  TWITTER_API_SECRET
  APP_URL
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY
  AWS_REGION
  REDIS_URL
)

prod_keys = %w(
  AWS_BUCKET
  SECRET_KEY_BASE
  SLACK_WEB_HOOK
  SENDGRID_USERNAME
  SENDGRID_PASSWORD
  OVPN_SERVER
  OVPN_USER
  OVPN_PASSWORD
)

figaro_required = if Rails.env.production?
  dev_keys + prod_keys
elsif Rails.env.development?
  dev_keys
end

Figaro.require_keys(*figaro_required)
