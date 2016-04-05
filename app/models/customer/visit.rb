class Customer::Visit < ActiveRecord::Base
  default_scope { order('created_at DESC') }

  scope :by_date, ->(date) { where(created_at: date.beginning_of_day..date.end_of_day) }
  scope :by_date_from_to, ->(from, to) { where(created_at: from..to.end_of_day) }
  scope :by_sms, -> { joins(:profile).where(profiles: { resource_type: "SmsProfile" }) }

  belongs_to :profile
  belongs_to :customer
  belongs_to :place
  belongs_to :network_profile, class_name: 'Customer::NetworkProfile',
             foreign_key: :customer_network_profile_id

  validates :place, :profile, presence: true
  validate :ones_a_day_visit

  after_create :calculate_reputation, unless: :by_password?

  def ones_a_day_visit
    now = DateTime.now
    visits = Customer::Visit.joins(:profile).where({
      profiles: {
        resource_type: profile.resource_type,
        resource_id: profile.resource_id
      },
      created_at: (now - now.hour.hours)..now,
      place_id: place_id
    })

    self.errors.add(:customer, I18n.t('models.errors.already_logged_in')) if visits.any?
  end

  def self.by_gender
    genders = Hash.new(0)

    includes(profile: :resource).each do |visit|
      gender = visit.profile.try(:resource).try(:gender)
      genders[gender] += 1
    end

    genders.except(nil)
  end

  def by_sms?
    Auth::ALTERNATIVE[:sms] == profile_name
  end

  def by_password?
    Auth::ALTERNATIVE[:password] == profile_name
  end

  def by_social_network?
    Auth::NETWORKS.has_value?(profile_name)
  end

  def font_awesome_name
    profile_name == "vkontakte" ? "vk" : profile_name
  end

  def calculate_reputation
    Customer::Reputation.calculate(self) if place.loyalty_program
  end

  def profile_name
    profile.resource_type.remove("Profile").downcase
  end
end
