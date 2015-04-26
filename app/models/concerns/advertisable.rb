module Advertisable
  def get_message(place, network)
    network = 'vk' if network == 'vkontakte'
    place.messages.where(network: Message.networks[network.to_sym]).first
  end
end
