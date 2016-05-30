def set_omniauth(options = {})
  credentials = options.merge({
    provider: :vkontakte,
    uid: Faker::Number.number(5),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    gender: "2",
    birthday: "23.7.1996",
    vk_url: Faker::Internet.url,
    access_token: "mocked_token",
    expires_at: Faker::Number.number(5)
  })

  OmniAuth.config.mock_auth[credentials[:provider]] = {
    "uid" => credentials[:uid],
    "provider" => credentials[:provider].to_s,

    "extra" => {
        "raw_info" => {
        "first_name" => credentials[:first_name],
        "last_name" => credentials[:last_name],
        "sex" => credentials[:gender],
        "bdate" => credentials[:birthday]
      }
    },

    "info" => {
      "urls" => {
        "Vkontakte" => credentials[:vk_url]
      }
    },

    "credentials" => {
      "token" => credentials[:access_token],
      "expires_at" => credentials[:expires_at]
    }
  }
end
