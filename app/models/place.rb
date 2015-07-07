require 'ext/string'

class Place < ActiveRecord::Base
  has_unique_slug :subject => Proc.new {|place| "#{Translit.convert(place.name, :english).urlize({:convert_spaces => true})}"}

  has_attached_file :logo,
                    :storage => :s3,
                    :path => "/images/logos/:id/:style.:extension",
                    :url => ":s3_domain_url"

  has_many :messages, :dependent => :destroy
  has_many :visits, :dependent => :destroy, class_name: 'Customer::Visit'
  has_many :stocks, :dependent => :destroy
  belongs_to :user

  before_validation :set_password, if: 'enter_by_password'

  validates :name, :template, presence: true
  validates :password, presence: true, if: 'enter_by_password'
  validates :wifi_settings_link, :redirect_url, format: { with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix,
                                                          message: I18n.t('errors.wrong_link_format')}
  validates_attachment :logo,
                       :content_type => { :content_type => ["image/jpeg", "image/png", "image/gif"] }

 before_save :set_wifi_link_freshnes
 after_save :gen_new_wifi_settings


  def get_networks
    networks_ids = self.messages
                       .where(active: true)
                       .select('social_network_id')
                       .map { |message| message.social_network_id }
                       .uniq

    SocialNetwork.where(id: networks_ids)
  end

  private
    def set_password
      if self.id && self.password == ''
        place = Place.find(self.id)
        self.password = place.password if place
      end
    end

    def set_wifi_link_freshnes
      if wifi_settings_link_not_fresh
        delete_settings_archive
        self.wifi_settings_link = nil
      end

      self.wifi_settings_link_not_fresh = true
    end

    # TODO: should be delayed
    def gen_new_wifi_settings
      WifiSettingsWorker.perform_async(id) unless wifi_settings_link
    end

    # TODO: should be delayed
    def delete_settings_archive
      S3UploaderService.delete_settings_archive_by_url(wifi_settings_link) if wifi_settings_link
    end
end
