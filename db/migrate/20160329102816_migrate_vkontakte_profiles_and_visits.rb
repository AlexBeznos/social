class MigrateVkontakteProfilesAndVisits < ActiveRecord::Migration
  def self.up
    # vk = SocialNetwork.find_by(name: 'vkontakte')
    #
    # if vk
    #   Customer::NetworkProfile.includes(:customer, :visits).where(social_network_id: vk.id).each_with_index do |customer_profile, index|
    #     if index > 52035
    #       vkontakte_profile_params = customer_profile.attributes.except(
    #         'id',
    #         'customer_id',
    #         'social_network_id',
    #         'access_token_secret',
    #         'created_at',
    #         'updated_at'
    #       )
    #
    #       vkontakte_customer_params = customer_profile.customer.attributes.slice(
    #         'first_name',
    #         'last_name',
    #         'gender',
    #         'birthday'
    #       )
    #
    #       params = vkontakte_profile_params.merge(vkontakte_customer_params)
    #
    #       profile = Profile.create!(
    #         customer_id: customer_profile.customer_id,
    #         resource_type: 'VkontakteProfile',
    #         resource_attributes: params
    #       )
    #
    #       customer_profile.visits.update_all(
    #         account_type: profile.resource_type,
    #         account_id: profile.resource_id
    #       )
    #     end
    #   end
    # end
  end

  def self.down
  end
end
# 
