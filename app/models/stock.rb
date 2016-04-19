class Stock < ActiveRecord::Base
  belongs_to :place

  mount_uploader :image, StockUploader, mount_on: :image_file_name
  
  validates :place_id, :days, presence: true
  validates :image,
            presence: true,
            file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif'] }

  before_save :normalize_day

  def proper_lang_days
    I18n.t('date.day_names').values_at(*days.map(&:to_i)).join(", ")
  end

  private

  def normalize_day
    self.days.reject!(&:blank?)
  end
end
