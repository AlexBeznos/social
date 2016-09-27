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


  def postable?
    Auth::NETWORKS.values.reject{ |net| net == "instagram" }.include? network_name
  end

  def network_name
    resource_type.remove("Profile").downcase
  end

  def font_awesome_name
    if network_name == "vkontakte"
      "vk"
    else
      network_name
    end
  end

  def self.find_by_credentials(credentials)
    resource_type = get_profile_type(credentials['provider']).constantize
    resource_params = resource_type.prepare_params(credentials)
    profile_resource = resource_type.find_by(uid: resource_params[:uid])

    if profile_resource
      profile_resource.profile
    end
  end

  def self.resource_like(provider, customer_id)
    resource = provider.capitalize

    where('resource_type LIKE ? AND customer_id = ?', "#{resource}%", customer_id)
  end

  def self.prepare_date(date)
    return nil unless date

    str_date = date
    str_date = str_date + ".1900" if str_date.length <= 5

    Date.parse(str_date)
  end

  def self.create_with_resource(params, customer)
    resource_type = get_profile_type(params['provider'] || params[:provider])

    create(
      customer: customer,
      resource_type: resource_type,
      resource_attributes: resource_type.constantize.prepare_params(params)
    )
  end

  def self.create_or_update(params, customer)
    profile_resource = find_by_credentials(params).try(:resource)

    if profile_resource
      resource_params = profile_resource.class.prepare_params(params)
      profile_resource.update!(resource_params)
      profile_resource.profile
    else
      create_with_resource(params, customer)
    end
  end

  def self.get_profile_type(provider)
    provider.classify + "Profile"
  end
end
