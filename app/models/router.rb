class Router < ActiveRecord::Base
  ALLOWED_CRTS = [
    'client.crt',
    'client.key',
    'ca.crt'
  ]

  OVPN_NAME_MATCH = {
    'client.crt' => 'cert',
    'client.key' => 'key',
    'ca.crt' => 'ca'
  }

  mount_uploader :ovpn, StandartUploader

  has_unique_slug column: :access_token, subject: Proc.new {
    SecureRandom.hex(12)
  }

  belongs_to :place

  validates :place, presence: true

  before_create :set_random_values
  before_create :set_client_ip
  after_commit :initial_setup, on: :create

  def crt_by_name(name)
    xml = Nokogiri::XML(ovpn.read)
    xml.css(OVPN_NAME_MATCH[name]).first.content
  end

  private

  def set_random_values
    self.username = SecureRandom.hex(6)
    self.password = SecureRandom.hex(6)
  end

  def set_client_ip
    begin
      self.client_ip = "192.#{rand(255)}.#{rand(255)}.#{rand(254)}"
    end until Router.where(client_ip: client_ip, place: place).empty?
  end

  def initial_setup
    RouterSuperworker.perform_async(id)
  end
end
