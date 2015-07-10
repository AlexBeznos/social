require 'cssminify'
class Style < ActiveRecord::Base
  belongs_to :place

  has_attached_file :background,
                    :storage => :s3,
                    :path => "/style/bachground/:id/:style.:extension",
                    :url => ":s3_domain_url"

  validates :text_color, :greating_color, :css_colour => true, :allow_blank => true
  validates_attachment :background, :presence => true,
                                :content_type => { :content_type => ["image/jpeg", "image/png", "image/gif"] }

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
