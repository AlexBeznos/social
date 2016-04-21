require 'fileless_io'

class Vpn::CertificatsPullingWorker
  include Sidekiq::Worker

  sidekiq_options queue: :ovpn, failures: true

  def perform(router_id)
    router = Router.find(router_id)
    ovpn = OvpnService.new({router: router})
    crt = FilelessIO.new(ovpn.get_certificate)
    crt.original_filename = 'ovpn.xml'

    router.ovpn = crt
    router.save!
  end
end
