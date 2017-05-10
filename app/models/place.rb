class Place < ActiveRecord::Base
  DOMAIN_LIST = [ "gofriends.com.ua", "go-friends.ru", "gofriends.by", "gofriends.kz", "gofriends.us" ]
  geocoded_by :city

  has_unique_slug subject: :ssid

  mount_uploader :logo, LogoUploader, mount_on: :logo_file_name

  has_one  :style, dependent: :destroy
  has_one  :router, dependent: :destroy

  has_many :banners, dependent: :destroy
  has_many :visits, dependent: :destroy, class_name: 'Customer::Visit'
  has_many :ahoy_visits, dependent: :destroy
  has_many :stocks, dependent: :destroy
  has_many :reputations, dependent: :destroy, class_name: 'Customer::Reputation'
  has_many :menu_items, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :auths, dependent: :destroy

  belongs_to :user

  default_value_for :auth_default_lang, I18n.default_locale.to_s

  validates :ssid, presence: true
  validates :ssid, length: { maximum: 9 },
                   format: { with: /\A[a-zA-Z]+\z/, message: I18n.t("models.errors.validations.english_letters_and_spaces") },
                   if: 'new_record? || created_at > Date.new(2016,02,12)' # NOTE: remove after implementation of remote router control

  validates :display_my_banners, inclusion: { in: [false] }, if: "self.city.blank?"
  validates :display_other_banners, inclusion: { in: [false] }, if: "self.city.blank?"
  validates :domen_url, inclusion: { in: Place::DOMAIN_LIST }
  validates :name, presence: true
  validates :logo, file_content_type: { allow: ["image/jpeg", "image/png", "image/gif"] },
                   file_size: { less_than_or_equal_to: 10.megabytes }

  after_validation :geocode, if: :city_changed?
  after_commit :setup_router, on: :create

  def get_customers
    Profile.joins(:visits).where('customer_visits.place_id = ?', self.id)
  end

  def get_proper_stock
    day = Date.today.wday

    stocks.where("days && '{#{day}}'::text[]").order("RANDOM()").first
  end

  def up_to_day
    self.update_attributes(access_count_day: 0)
  end

  def up_to_week
    self.update_attributes(access_count_week: 0)
  end

  def up_to_month
    self.update_attributes(access_count_month: 0)
  end

  def by_date_for_place(date)
    Place.where(updated_at: date.beginning_of_day..date.end_of_day, access_count_day: self.access_count_day)
  end

  def by_date_from_to_for_place(from, to)
    Place.where(updated_at: from..to.end_of_day, access_count: self.access_count)
  end

  private

  def setup_router
    WifiRouter::SetupWorker.perform_async(id)
  end
end
