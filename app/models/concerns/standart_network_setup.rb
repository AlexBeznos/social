module StandartNetworkSetup
  extend ActiveSupport::Concern

  included do
    validates :message, :message_url, :image, presence: true
  end
end
