class Profile < ActiveRecord::Base
  belongs_to :customer
  belongs_to :resource, polymorphic: true, dependent: :destroy
  has_many :visits, class_name: Customer::Visit, dependent: :destroy

  accepts_nested_attributes_for :resource

  validates :customer_id, presence: true

  def resource_attributes=(attributes, options = {})
    if persisted?
      super attributes
    else
      self.resource = resource_type.constantize.new(attributes, options)
    end
  end

  def full_name
    first_name = resource.try(:first_name) || resource.try(:name)
    last_name = resource.try(:last_name)
    full_name = [first_name, last_name].compact.join(" ")

    full_name.present? ? full_name : nil
  end

  def self.resource_like(provider, customer_id)
    resource = provider.capitalize

    where('resource_type LIKE ? AND customer_id = ?', "#{resource}%", customer_id)
  end

  def self.prepare_date(date)
    str_date = date
    str_date = str_date + ".1900" if str_date.length <= 5

    Date.parse(str_date)
  end

  def self.create_with_resource(params, customer)
    resource_type = get_profile_type(params['provider'] || params[:provider])

    create!(
      customer: customer,
      resource_type: resource_type,
      resource_attributes: get_resource_params(resource_type, params)
    )
  end

  def self.create_or_update(params, customer)
    resource_type = get_profile_type(params['provider'])
    resource_params = get_resource_params(resource_type, params)
    profile_resource = resource_type.constantize.find_by(uid: resource_params[:uid])

    if profile_resource
      profile_resource.update!(resource_params)
      profile_resource.profile
    else
      create_with_resource(params, customer)
    end
  end

  def self.get_profile_type(provider)
    provider.capitalize + "Profile"
  end

  def self.get_resource_params(resource_type, credentials)
    resource_type.constantize.try(:prepare_params, credentials)
  end
end
