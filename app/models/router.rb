class Router < ActiveRecord::Base
  API_USERNAME = 'gofriends_api' # NOTE: never change it, unless you know what you do
  OVPN_NAME_MATCH = {
    'client.crt' => 'cert',
    'client.key' => 'key',
    'ca.crt' => 'ca'
  }

  ALLOWED_CRTS = OVPN_NAME_MATCH.keys

  mount_uploader :ovpn, StandartUploader
  mount_uploader :login_page, StandartUploader
  mount_uploader :settings, StandartUploader

  has_unique_slug column: :access_token, subject: Proc.new {
    SecureRandom.hex(12)
  }

  belongs_to :place

  validates :place, presence: true

  before_create :set_random_values
  before_create :set_ip
  after_commit :initial_setup, on: :create

  def crt_by_name(name)
    xml = Nokogiri::XML(ovpn.read)
    xml.css(OVPN_NAME_MATCH[name]).first.content
  end

  private

  def set_random_values
    self.hp_username ||= SecureRandom.hex(6)
    self.hp_password ||= SecureRandom.hex(6)
    self.mt_api_password = SecureRandom.hex(8)
    self.mt_password = SecureRandom.hex(8)
  end

  def set_ip
    begin
      self.ip = "192.#{rand(255)}.#{rand(255)}.#{rand(254)}"
    end until Router.where(ip: ip, place: place).empty?
  end

  def initial_setup
    RouterSuperworker.perform_async(id)
  end
end
