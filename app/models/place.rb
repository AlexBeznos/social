# require 'ext/string'

class Place < ActiveRecord::Base
  DOMAIN_LIST = [ "gofriends.com.ua", "go-friends.ru", "gofriends.by", "gofriends.kz" ]
  geocoded_by :city

  has_unique_slug subject: :ssid

  mount_uploader :logo, LogoUploader, mount_on: :logo_file_name

  has_one  :style, dependent: :destroy
  has_many :banners, dependent: :destroy
  has_many :visits, dependent: :destroy, class_name: 'Customer::Visit'
  has_many :stocks, dependent: :destroy
  has_many :reputations, dependent: :destroy, class_name: 'Customer::Reputation'
  has_many :social_network_icons, dependent: :destroy
  has_many :menu_items, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :auths, dependent: :destroy
  has_many :gowifi_sms, :dependent => :destroy, class_name: 'GowifiSms'

  belongs_to :user

  default_value_for :auth_default_lang, I18n.default_locale.to_s

  validates :ssid, presence: true
  validates :ssid, length: { maximum: 9 },
                   format: { with: /\A[a-zA-Z]+\z/, message: I18n.t("models.errors.validations.english_letters_and_spaces") },
                   if: 'persisted? && created_at > Date.new(2016,02,12)' # NOTE: remove after implementation of remote router control

  validates :display_my_banners, inclusion: { in: [false] }, if: "self.city.blank?"
  validates :display_other_banners, inclusion: { in: [false] }, if: "self.city.blank?"
  validates :domen_url, inclusion: { in: Place::DOMAIN_LIST }
  validates :name, :template, presence: true
  validates :logo, file_content_type: { allow: ["image/jpeg", "image/png", "image/gif"] },
                   file_size: { less_than_or_equal_to: 10.megabytes }

  after_validation :geocode, if: :city_changed?
  before_create :set_wifi_username_password
  before_save :set_wifi_link_freshnes
  after_save :gen_new_wifi_settings

  def get_customers
    Customer.joins(:visits).where('customer_visits.place_id = ?', self.id)
  end

  def get_proper_stock
    day = Date.today.strftime('%A')
    days_arr = I18n.t('date.day_names', locale: :en)

    stocks.where('day = ? or day not in (?)', day, days_arr).order("RANDOM()").first
  end

  private
  def set_wifi_link_freshnes
    if wifi_settings_link_not_fresh
      delete_settings_archive
      self.wifi_settings_link = nil
    end

    self.wifi_settings_link_not_fresh = true
  end

  def gen_new_wifi_settings
    WifiSettingsWorker.perform_async(id) unless wifi_settings_link
  end

  # TODO: should be delayed
  def delete_settings_archive
    S3UploaderService.delete_settings_archive_by_url(wifi_settings_link) if wifi_settings_link
  end

  def set_wifi_username_password
    self.wifi_username, self.wifi_password = SecureRandom.hex(6), SecureRandom.hex(6)
  end
end
