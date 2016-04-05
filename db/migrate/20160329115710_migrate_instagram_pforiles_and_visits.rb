class MigrateInstagramPforilesAndVisits < ActiveRecord::Migration
  def self.up
    instagram = SocialNetwork.find_by(name: 'instagram')

    if instagram
      Customer::NetworkProfile.includes(:customer, :visits).where(social_network_id: instagram.id).each do |customer_profile|
        instagram_profile_params = customer_profile.attributes.except(
          'id',
          'customer_id',
          'social_network_id',
          'created_at',
          'updated_at',
          'friends_count',
          'access_token_secret',
          'expiration_date'
        )

        customer = customer_profile.customer

        user_name = if customer.last_name.nil?
                      customer.first_name
                    else
                      "#{customer.first_name} #{customer.last_name}"
                    end

        instagram_customer_params = {
          'name' => user_name,
          'nickname' => customer_profile.url.split("/").last
        }

        params = instagram_profile_params.merge(instagram_customer_params)

        profile = Profile.create!(
          customer_id: customer_profile.customer_id,
          resource_type: 'InstagramProfile',
          resource_attributes: params
        )

        customer_profile.visits.update_all(profile_id: profile.id)
      end
    end
  end

  def self.down
  end
end
