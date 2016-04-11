class Router < ActiveRecord::Base
  belongs_to :place

  validates :username, :password, presence: true
  validates :client_ip, uniqueness: true

  before_validation :set_random_values
  after_commit :gen_ovpn_client, unless: :ovpn_ready

  private

  def set_random_values
    self.client_ip = "192.#{rand(255)}.#{rand(255)}.#{rand(254)}"
    self.client_pass = SecureRandom.hex(12)
    self.username = SecureRandom.hex(6)
    self.password = SecureRandom.hex(6)
  end

  def gen_ovpn_client
    Vpn::ClientSetupWorker.perform_async(id)
  end
end
