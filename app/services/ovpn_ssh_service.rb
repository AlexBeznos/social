require 'uri/open-scp'

class OvpnSshService
  def initialize(attrs)
    @router = attrs[:router]
    @client_name = Place.select(:slug).find(@router.place_id).slug
  end

  def setup_client
    stdout = ''

    ssh_connection do |ssh|
      stdout = ssh.exec!(setup_client_cmnds(@client_name, @router.client_ip))
    end

    unless stdout.include? 'Write out database with 1 new entries'
      Rails.logger.debug stdout
      return raise
    end
  end

  def get_certificate
    cmnd = [ data_volume, gen_ovpn_client_file(@client_name) ].join(' && ')
    stdout = ''

    ssh_connection do |ssh|
      stdout = ssh.exec!(cmnd)
    end

    if stdout.present?
      Rails.logger.debug stdout
      return raise
    end

    open(scp_client_path(@client_name)).read
  end

  private

  def ssh_connection(&ssh)
    Net::SSH.start(ENV['OVPN_SERVER'], ENV['OVPN_USER']) do |connection|
      ssh.call connection
    end
  end

  def setup_client_cmnds(client_name, client_ip)
    [
      data_volume,
      build_client(client_name),
      set_static_ip(client_name, client_ip)
    ].join(' && ')
  end

  def data_volume
    "OVPN_DATA='ovpn-data'"
  end

  def build_client(client_name)
    "docker run --volumes-from $OVPN_DATA --rm -i beznosa/openvpn-mikrotik easyrsa build-client-full #{client_name} nopass"
  end

  def set_static_ip(client_name, client_ip)
    "docker run --volumes-from $OVPN_DATA --rm -i beznosa/openvpn-mikrotik ovpn_staticip #{client_name} #{client_ip}"
  end

  def gen_ovpn_client_file(client_name)
    "docker run --volumes-from $OVPN_DATA --rm -i beznosa/openvpn-mikrotik ovpn_xml_getclient #{client_name} > #{client_name}.xml"
  end

  def scp_client_path(client_name)
    "scp://#{ENV['OVPN_USER']}@#{ENV['OVPN_SERVER']}/#{ENV['OVPN_USER']}/#{client_name}.xml"
  end
end
