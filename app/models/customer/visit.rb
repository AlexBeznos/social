class Customer::Visit < ActiveRecord::Base
  default_scope { order('created_at DESC') }

  scope :by_date, lambda {|date| where(created_at: date.beginning_of_day..date.end_of_day) }
  scope :by_date_from_to, lambda {|from, to| where(created_at: from..to.end_of_day) }
  scope :by_gender, lambda {|gender = 'f'| where('customers.gender = ?', gender == 'm' ? 'male' : 'female') }

  belongs_to :customer
  belongs_to :place
  belongs_to :network_profile,  :class_name => 'Customer::NetworkProfile',
                                :foreign_key => :customer_network_profile_id

  validates :network_profile, :place,  presence: true, unless: 'by_password'
  validate :visiting_ones_a_half_an_hour, unless: 'by_password'

  after_commit :calculate_reputation

  private
    def visiting_ones_a_half_an_hour
      now = DateTime.now
      Rails.logger.warn 'visit validation start'
      Rails.logger.warn network_profile.uid
      Rails.logger.warn network_profile.social_network_id
      any_visits =  Customer::Visit.joins(:network_profile)
                                   .where({
                                           :customer_network_profiles => {:social_network_id => network_profile.social_network_id},
                                           :customer_network_profiles => {:uid => network_profile.uid},
                                           :created_at => (now - now.hour.hours)..now,
                                           :place_id => place_id})
      Rails.logger.warn any_visits.inspect
      self.errors.add(:customer, I18n.t('models.errors.already_logged_in')) if any_visits.any?
    end

    def calculate_reputation
      Customer::Reputation.calculate(self)
    end
end
