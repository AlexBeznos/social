class MenuItem < ActiveRecord::Base
  belongs_to :place
  has_and_belongs_to_many :orders

  has_attached_file :image,
                    :storage => :s3,
                    :path => "/images/:id/:style.:extension",
                    :url => ":s3_domain_url"

  validates :name, :price, :place_id, presence: true
  validates_attachment :image, :presence => true,
                       size: { in: 11.kilobytes..10.megabytes },
                       :content_type => { :content_type => ["image/jpeg", "image/png", "image/gif"] }

  scope :pagination, -> (page_params) { page(page_params).per(3) }

end
