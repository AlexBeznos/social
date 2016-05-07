require 'cssminify'
class Style < ActiveRecord::Base
  has_many :social_network_icons, dependent: :destroy
  belongs_to :place

  accepts_nested_attributes_for :social_network_icons, allow_destroy: true

  mount_uploader :background, BackgroundUploader, mount_on: :background_file_name

  validates :text_color, :greating_color, css_colour: true, allow_blank: true
  validates :background,
            file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif'] },
            file_size: { less_than_or_equal_to: 10.megabytes }

  before_save :precompile_css, if: -> { css_changed? }
  before_save :precompile_js, if: -> { js_changed? }

  private

  def precompile_css
    self.css_min = CSSminify.compress(css)
  end

  def precompile_js
    self.js_min = Uglifier.compile(js)
  rescue
    errors.add(:js, I18n.t('models.errors.js_precompilation'))
  end
end
