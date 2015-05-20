module Advertisable
  def get_message(place, network)
    place.messages.active.where(social_network: SocialNetwork.find_by(name: network)).first
  end

  def create_consumer(provider, credentials)
    social_network = SocialNetwork.find_by(name: provider)

    unless Costumer.where("social_network_id = ? and uid = ?", social_network, credentials['uid']).any?
      case provider
      when 'twitter'
        Costumer.create(social_network: SocialNetwrok.find_by(name: provider),
                        name: credentials['info']['name'],
                        url: credentials['info']['urls']['Twitter'],
                        uid: credentials['uid'],
                        friends_count: credentials['extra']['raw_info']['followers_count'])
      end
    end
  end
end
