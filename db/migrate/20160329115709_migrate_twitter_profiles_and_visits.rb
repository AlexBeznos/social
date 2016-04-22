class MigrateTwitterProfilesAndVisits < ActiveRecord::Migration
  def self.up
    twitter = SocialNetwork.find_by(name: 'twitter')

    if twitter
      Customer::NetworkProfile.includes(:customer, :visits).where(social_network_id: twitter.id).each do |customer_profile|
        twitter_profile_params = customer_profile.attributes.except(
          'id',
          'customer_id',
          'social_network_id',
          'created_at',
          'updated_at'
        )

        twitter_customer_params = { 'name' => customer_profile.customer.first_name }
        params = twitter_profile_params.merge(twitter_customer_params)

        profile = Profile.create!(
          customer_id: customer_profile.customer_id,
          resource_type: 'TwitterProfile',
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
