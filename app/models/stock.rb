class Stock < ActiveRecord::Base
  belongs_to :place

  has_attached_file :image,
                    :storage => :s3,
                    :path => "/images/stocks/:id/:style.:extension",
                    :url => ":s3_domain_url"

  validate :place_id, presence: true
  validates :url, format: { with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix,
                            message: I18n.t('errors.wrong_link_format')}
  validates_attachment :image, :presence => true,
                                :content_type => { :content_type => ["image/jpeg", "image/png", "image/gif"] }
end
