class OvpnService
  def initialize(attrs)
    @router = attrs[:router]
    @place = @router.place
  end

  def create_client # FIXME: make it work with docker
    Net::SSH.start('46.101.213.72', 'root') do |ssh| # FIXME: ip, user move to env vars
      # NOTE: should be by one line
      ssh.exec! "cd /etc/openvpn/easy-rsa && source vars && ./pkitool #{@place.slug}"
    end
  end

  private

  # def build_client(client_name)
  #   "docker run --volumes-from $OVPN_DATA --rm -it beznosa/docker-openvpn-staticip easyrsa build-client-full #{client_name} nopass"
  # end
  #
  # def ovpn_staticip(client_name, client_ip)
  #   "docker run --volumes-from $OVPN_DATA --rm -it beznosa/docker-openvpn-staticip ovpn_staticip #{client_name} #{client_ip}"
  # end
end
