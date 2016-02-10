class Stock < ActiveRecord::Base
  belongs_to :place

  # has_attached_file :image,
  #                   :storage => :s3,
  #                   :path => "/images/stocks/:id/:style.:extension",
  #                   :url => ":s3_domain_url"
  mount_uploader :image, ImageUploader, mount_on: :image_file_name

  validates :place_id, :day, presence: true
  validates :url, :url => true
  # validates_attachment :image, :presence => true,
  #                               :content_type => { :content_type => ["image/jpeg", "image/png", "image/gif"] }

  before_save :normalize_day

  def proper_lang_day
    index = I18n.t('date.day_names',  :locale => :en).index(day)
    index ? I18n.t('date.day_names')[index] : day
  end

  private
  def normalize_day
    index = I18n.t('date.day_names').index(day)
    self.day = if index
      I18n.t('date.day_names', :locale => :en)[index]
    else
      day
    end
  end
end
