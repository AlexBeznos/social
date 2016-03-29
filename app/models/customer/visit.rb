class Customer::Visit < ActiveRecord::Base
  default_scope { order('created_at DESC') }

  scope :by_date, lambda { |date| where(created_at: date.beginning_of_day..date.end_of_day) }
  scope :by_date_from_to, lambda { |from, to| where(created_at: from..to.end_of_day) }
  scope :by_gender, lambda { |gender = 'f'| where('customers.gender = ?', gender == 'm' ? 'male' : 'female') }

  belongs_to :profile
  belongs_to :customer
  belongs_to :place

  validates :network_profile, :place, presence: true, if: -> (r) {
    Auth::NETWORKS.values.include?(profile.resource_type.underscore.gsub(/\_profile/, ''))
  }
  # validate :ones_a_day_visit, unless: 'by_password'
  # validates :network_profile, :place, presence: true, unless: :by_password
  validates :profile_id, presence: true
  validate :ones_a_day_visit


  after_create :calculate_reputation, unless: :by_password

  private

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

  def calculate_reputation
    Customer::Reputation.calculate(self) if place.loyalty_program
  end
end
