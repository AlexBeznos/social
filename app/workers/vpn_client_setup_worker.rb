class VpnClientSetupWorker
  include Sidekiq::Worker

  sidekiq_options queue: :ovpn_setup, failures: true

  def perform(router_id)
    router = Router.find(router_id)
    ovpn = OvpnService.new({router: router})

    ovpn.create_client
  end
end
