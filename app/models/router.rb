class Router < ActiveRecord::Base
  mount_uploader :ovpn, StandartUploader

  belongs_to :place

  validates :username, :password, :place, presence: true

  before_create :set_random_values
  before_create :set_client_ip
  after_commit :gen_ovpn_client, on: :create

  private

  def set_random_values
    self.username = SecureRandom.hex(6) unless username
    self.password = SecureRandom.hex(6) unless password
    self.access_token = SecureRandom.hex(12)
  end

  def set_client_ip
    begin
      self.client_ip = "192.#{rand(255)}.#{rand(255)}.#{rand(254)}"
    end until Router.where(client_ip: client_ip, place: place).empty?
  end

  def gen_ovpn_client
    RouterSuperworker.perform_async(id)
  end
end
