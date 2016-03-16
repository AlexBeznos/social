class MigrateTwitterProfiles < ActiveRecord::Migration
  def self.up
    twitter = SocialNetwork.find_by(name: 'twitter')

    if twitter
      Customer::NetworkProfile.includes(:customer).where(social_network_id: twitter.id).each do |customer_profile|
        twitter_profile_params = customer_profile.attributes.except(
          'id',
          'customer_id',
          'social_network_id',
          'created_at',
          'updated_at'
        )

        twitter_customer_params = customer_profile.customer.attributes.slice(
          'first_name',
          'last_name',
          'gender'
        )

        params = twitter_profile_params.merge(twitter_customer_params)

        Profile.create!(
          customer_id: customer_profile.customer_id,
          resource_type: 'TwitterProfile',
          resource_attributes: params
        )
      end
    end
  end

  def self.down
  end
end
