require 'fileless_io'

class WifiRouter::LoginPageWorker
  include Rails.application.routes.url_helpers
  include Sidekiq::Worker

  sidekiq_options queue: :router_setup, failures: true

  def perform(router_id)
    router = Router.find(router_id)
    gowifi_url = "http://wifi.gofriends.com.ua#{gowifi_place_path(router.place)}"
    login_path = File.join(Rails.root, 'vendor/router/samples/login.html')
    login_io = File.open(login_path).read

    login_io.gsub! /##LOGIN_PAGE##/, gowifi_url

    login_fileless = FilelessIO.new(login_io)
    login_fileless.original_filename = 'login.html'

    router.login_page = login_fileless
    router.save!
  end
end
