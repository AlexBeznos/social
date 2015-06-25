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
  validate :visiting_ones_a_half_an_hour

  private
    def visiting_ones_a_half_an_hour
      now = DateTime.now
      any_visits =  Customer::Visit.joins(:network_profile)
                                   .where({:customer_network_profiles => {:uid => network_profile.uid},
                                           :customer_network_profiles => {:social_network_id => network_profile.social_network_id},
                                           :created_at => (now - 15.minutes)..now,
                                           :place_id => place_id})
                                   .any?
      self.errors.add(:customer, 'Already logged in') if any_visits
    end
end
