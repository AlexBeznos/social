class MigrateVkontakteProfiles < ActiveRecord::Migration
  def self.up
    vk = SocialNetwork.find_by(name: 'vkontakte')

    if vk
      Customer::NetworkProfile.includes(:customer).where(social_network_id: vk.id).each do |customer_profile|
        vkontakte_profile_params = customer_profile.attributes.except(
          'id',
          'customer_id',
          'social_network_id',
          'access_token_secret',
          'created_at',
          'updated_at'
        )

        vkontakte_customer_params = customer_profile.customer.attributes.slice(
          'first_name',
          'last_name',
          'gender'
        )

        params = vkontakte_profile_params.merge(vkontakte_customer_params)

        Profile.create!(
          customer_id: customer_profile.customer_id,
          resource_type: 'VkontakteProfile',
          resource_attributes: params
        )
      end
    end
  end

  def self.down
  end
end
