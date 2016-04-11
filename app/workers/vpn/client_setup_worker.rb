class Vpn::ClientSetupWorker
  include Sidekiq::Worker

  sidekiq_options queue: :ovpn, failures: true

  def perform(router_id)
    router = Router.find(router_id)
    ovpn = OvpnService.new({router: router})

    ovpn.setup_client
  end
end
