class Stock < ActiveRecord::Base
  belongs_to :place

  mount_uploader :image, StockUploader, mount_on: :image_file_name

  validates :place_id, :day, presence: true
  validates :image,
            presence: true,
            file_content_type: { allow: ["image/jpeg", "image/png", "image/gif"] }

  before_save :normalize_day

  def proper_lang_day
    index = I18n.t('date.day_names',  :locale => :en).index(day)
    index ? I18n.t('date.day_names')[index] : day
  end

  private
  def normalize_day
    index = I18n.t('date.day_names').index(day)
    self.day = if index
      I18n.t('date.day_names', locale: :en)[index]
    else
      day
    end
  end
end
