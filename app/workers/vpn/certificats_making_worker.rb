require 'fileless_io'

class Vpn::CertificatsMakingWorker
  include Sidekiq::Worker

  sidekiq_options queue: :ovpn, failures: true

  def perform(router_id)
    router = Router.find(router_id)
    ovpn = OvpnSshService.new({router: router})

    ovpn.make_certificate
  end
end
