module Advertisable
  def get_message(place, network)
    place.messages.where(network: Message.networks[network.to_sym]).first
  end
end
