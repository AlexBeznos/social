module Advertisable
  def get_message(place, network)
    place.messages.where(network: Message.networks[network.to_sym]).first
  end

  def create_consumer(provider, credentials)
    unless Costumer.where("network = ? and uid = ?", Costumer.networks[provider.to_sym], credentials['uid']).any?
      case provider
      when 'twitter'
        Costumer.create(network: provider,
                        name: credentials['info']['name'],
                        url: credentials['info']['urls']['Twitter'],
                        uid: credentials['uid'],
                        friends_count: credentials['extra']['raw_info']['followers_count'])
      end
    end
  end
end
