require 'uri/open-scp'

class OvpnSshService
  def initialize(attrs)
    @router = attrs[:router]
    @router_name = Place.select(:slug).find(@router.place_id).slug
  end

  def setup_client
    stdout = ''

    ssh_connection do |ssh|
      stdout = ssh.exec!(setup_client_cmnds(@router_name, @router.ip))
    end

    unless stdout.include? 'Write out database with 1 new entries'
      Rails.logger.debug stdout
      return raise RuntimeError.new(stdout)
    end
  end

  def make_certificate
    cmnd = [ data_volume, gen_ovpn_client_file(@router_name) ].join(' && ')
    stdout = ''

    ssh_connection do |ssh|
      stdout = ssh.exec!(cmnd)
    end

    if stdout.present?
      Rails.logger.debug stdout
      return raise RuntimeError.new(stdout)
    end
  end

  def get_certificate
    open(scp_client_path(@router_name), ssh: { password: ENV['OVPN_PASSWORD'] }).read
  end

  private

  def ssh_connection(&ssh)
    Net::SSH.start(ENV['OVPN_SERVER'], ENV['OVPN_USER'], password: ENV['OVPN_PASSWORD']) do |connection|
      ssh.call connection
    end
  end

  def setup_client_cmnds(router_name, ip)
    [
      data_volume,
      build_client(router_name),
      set_static_ip(router_name, ip)
    ].join(' && ')
  end

  def data_volume
    "OVPN_DATA='ovpn-data'"
  end

  def build_client(router_name)
    "docker run --volumes-from $OVPN_DATA --rm -i beznosa/openvpn-mikrotik easyrsa build-client-full #{router_name} nopass"
  end

  def set_static_ip(router_name, ip)
    "docker run --volumes-from $OVPN_DATA --rm -i beznosa/openvpn-mikrotik ovpn_staticip #{router_name} #{ip}"
  end

  def gen_ovpn_client_file(router_name)
    "docker run --volumes-from $OVPN_DATA --rm -i beznosa/openvpn-mikrotik ovpn_xml_getclient #{router_name} > #{router_name}.xml"
  end

  def scp_client_path(router_name)
    "scp://#{ENV['OVPN_USER']}@#{ENV['OVPN_SERVER']}/#{ENV['OVPN_USER']}/#{router_name}.xml"
  end
end
