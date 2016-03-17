class Customer::Visit < ActiveRecord::Base
  default_scope { order('created_at DESC') }

  scope :by_date, lambda { |date| where(created_at: date.beginning_of_day..date.end_of_day) }
  scope :by_date_from_to, lambda { |from, to| where(created_at: from..to.end_of_day) }
  scope :by_gender, lambda { |gender = 'f'| joins(:customer).where('customers.gender = ?', gender == 'm' ? 'male' : 'female') }

  belongs_to :customer
  belongs_to :place
  belongs_to :network_profile, class_name: 'Customer::NetworkProfile',
                               foreign_key: :customer_network_profile_id

  validates :network_profile, :place, presence: true, unless: 'by_password || by_sms'
  validate :ones_a_day_visit, unless: 'by_password || by_sms'

  after_create :calculate_reputation, unless: 'by_password || by_sms'

  private
  def ones_a_day_visit
    now = DateTime.now
    visits =  Customer::Visit.joins(:network_profile).where({
      customer_network_profiles: {
        social_network_id: network_profile.social_network_id,
        uid: network_profile.uid
      },
      created_at: (now - now.hour.hours)..now,
      place_id: place_id
    })

    self.errors.add(:customer, I18n.t('models.errors.already_logged_in')) if visits.any?
  end

  def calculate_reputation
    Customer::Reputation.calculate(self) if place.loyalty_program
  end
end
