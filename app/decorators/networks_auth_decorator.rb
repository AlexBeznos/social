class NetworksAuthDecorator
  extend ActiveModel::Callbacks

  attr_accessor :profile, :credentials, :auth, :place, :customer_id, :visit

  define_model_callbacks :save

  before_save :set_customer
  after_save :advertise

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def save
    run_callbacks :save do
      self.profile = Profile.create_or_update(credentials, @customer)
      self.visit = Customer::Visit.create(
        place: place,
        account_id: profile.resource_id,
        account_type: profile.resource_type,
        customer: @customer
      )

      self
    end
  end

  private

  def set_customer
    @customer = Profile.find_by_credentials(credentials).try(:customer)

    if @customer && current_user_session.customer != @customer
      current_user_session.customer.destroy
      current_user_session.update(customer: @customer)
    else
      @customer ||= Profile.find_by_credentials(credentials).try(:customer)
      @customer ||= Customer.create
    end
  end

  def advertise
    unless visit.errors.any? || !auth.resource.try(:posting_enabled?)
      AdvertisingWorker.perform_async(
        place.slug,
        auth.id,
        profile.id
      )
    end
  end
end
