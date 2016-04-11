class OvpnService
  def initialize(attrs)
    @router = attrs[:router]
    @client_name = Place.select(:slug).find(@router.place_id).slug
  end

  def setup_client
    stdout = ''

    ovpn_connect do |ssh|
      stdout = ssh.exec!(setup_client_cmnds(@client_name, @router.client_ip))
    end

    raise unless stdout.include? 'Write out database with 1 new entries'
  end

  def get_certificates
    {}
  end

  private

  def ovpn_connect(&ssh)
    Net::SSH.start(ENV['OVPN_SERVER'], ENV['OVPN_USER']) do |connection|
      ssh.call connection
    end
  end

  def build_client(client_name)
    "docker run --volumes-from $OVPN_DATA --rm -i beznosa/openvpn-mikrotik easyrsa build-client-full #{client_name} nopass"
  end

  def set_static_ip(client_name, client_ip)
    "docker run --volumes-from $OVPN_DATA --rm -i beznosa/openvpn-mikrotik ovpn_staticip #{client_name} #{client_ip}"
  end

  def setup_client_cmnds(client_name, client_ip)
    [
      "OVPN_DATA='ovpn-data'",
      build_client(client_name),
      set_static_ip(client_name, client_ip)
    ].join(' && ')
  end
end
