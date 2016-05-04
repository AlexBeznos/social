class NetworksAuthDecorator
  extend ActiveModel::Callbacks

  attr_accessor :profile, :customer, :credentials, :auth, :place, :customer_id, :visit

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
      self.profile = Profile.create_or_update(credentials, customer)
      self.visit = Customer::Visit.create(
        place: place,
        account_id: profile.resource_id,
        account_type: profile.resource_type,
        customer: customer
      )

      self
    end
  end

  private

  def set_customer
    @customer = Customer.find(customer_id.to_i) if customer_id.present?
    @customer ||= Customer.create
  end

  def advertise
    AdvertisingWorker.perform_async(
      place.slug,
      auth.id,
      profile.id
    ) if visit
  end
end
