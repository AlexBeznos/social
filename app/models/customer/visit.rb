class Customer::Visit < ActiveRecord::Base
  default_scope { order('created_at DESC') }

  scope :by_date, ->(date) { where(created_at: date.beginning_of_day..date.end_of_day) }
  scope :by_date_from_to, ->(from, to) { where(created_at: from..to.end_of_day) }
  scope :by_sms, -> { where(account_type: "SmsProfile") }
  scope :by_social_network, -> { where(account_type: Auth.network_classes) }

  belongs_to :account, polymorphic: true
  belongs_to :customer
  belongs_to :place

  validates :place, presence: true
  validate :ones_a_day_visit, unless: :by_password? || :by_sms?

  after_create :calculate_reputation, unless: :by_password? || :by_sms?

  def self.by_birthday(from, till)
    includes(:account).where(account_type: "VkontakteProfile").reject do |visit|
      !visit.within_date?(from, till)
    end.map(&:account).sort_by { |x| [x.birthday.month, x.birthday.day] }
  end

  def self.by_gender
    genders = Hash.new(0)

    includes(:account).each do |visit|
      gender = visit.try(:account).try(:gender)
      genders[gender] += 1
    end

    genders.except(nil)
  end

  def within_date?(from, till)
    return false if account.birthday.nil?
    birthday_day, birthday_month = [account.birthday.day, account.birthday.month]

    (from.day..from.end_of_month.day).include?(birthday_day) && from.month == birthday_month || (1..till.day).include?(birthday_day) && till.month == birthday_month
  end

  def font_awesome_name
    profile_name == "vkontakte" ? "vk" : profile_name
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

  private

  def ones_a_day_visit
    now = DateTime.now
    visits = Customer::Visit.where({
      account_type: account_type,
      account_id: account_id,
      created_at: (now - now.hour.hours)..now,
      place_id: place_id
    })

    self.errors.add(:customer, I18n.t('models.errors.already_logged_in')) if visits.any?
  end

  def calculate_reputation
    Customer::Reputation.calculate(self) if place.loyalty_program
  end

  def profile_name
    account_type.remove("Profile").downcase if account_type
  end
end
