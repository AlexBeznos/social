class MigrateFacebookProfilesAndVisits < ActiveRecord::Migration
  def self.up
    facebook = SocialNetwork.find_by(name: 'facebook')

    if facebook
      Customer::NetworkProfile.includes(:customer, :visits).where(social_network_id: facebook.id).each do |customer_profile|
        facebook_profile_params = customer_profile.attributes.except(
          'id',
          'customer_id',
          'social_network_id',
          'access_token_secret',
          'created_at',
          'updated_at'
        )

        facebook_customer_params = customer_profile.customer.attributes.slice(
          'first_name',
          'last_name',
          'gender'
        )

        params = facebook_profile_params.merge(facebook_customer_params)

        profile = Profile.create!(
          customer_id: customer_profile.customer_id,
          resource_type: 'FacebookProfile',
          resource_attributes: params
        )

        customer_profile.visits.update_all(
          account_type: profile.resource_type,
          account_id: profile.resource_id
        )
      end
    end
  end

  def self.down
  end
end
