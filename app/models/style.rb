require 'cssminify'
class Style < ActiveRecord::Base
  has_many :social_network_icons, :dependent => :destroy
  belongs_to :place

  accepts_nested_attributes_for :social_network_icons, :allow_destroy => true

  # has_attached_file :background,
  #                   :storage => :s3,
  #                   :path => "/style/bachground/:id/:style.:extension",
  #                   :url => ":s3_domain_url"
  mount_uploader :background, BackgroundUploader, mount_on: :background_file_name

  validates :text_color, :greating_color, :css_colour => true, :allow_blank => true
  # validates_attachment :background, :content_type => { :content_type => ["image/jpeg", "image/png", "image/gif"] }

  before_save :precompile_css, if: 'css'
  before_save :precompile_js, if: 'js'

  private
    def precompile_css
      self.css_min = CSSminify.compress(css)
    end

    def precompile_js
      begin
        self.js_min = Uglifier.compile(js)
      rescue
        errors.add(:js, I18n.t('models.errors.js_precompilation'))
      end
    end
end
