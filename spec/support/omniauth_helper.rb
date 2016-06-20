def set_omniauth(provider, options = {})
  omniauth_path = Rails.root.join('spec', 'support', 'fixtures', 'omniauth.yml')
  credentials = YAML.load_file(omniauth_path)[provider]
  credentials.merge!(options)

  OmniAuth.config.mock_auth[provider.to_sym] = credentials
end
