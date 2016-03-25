module Consumerable
  def redis_ready_credentials(credentials)
    service = "#{credentials['provider'].capitalize}Service".constantize
    service.get_token(credentials)
  end

  def find_or_create_customer(credentials, place, customer = false)
    customer = customer || Customer.create
    profile = Profile.create_with_resource(credentials, customer)
    visit = create_visit(profile, place)

    { visit: visit, customer: customer }
  end

  def create_visit(profile, place)
    Customer::Visit.create(
      place: place,
      profile: profile,
      customer_id: profile.customer_id
    )
  end
end
