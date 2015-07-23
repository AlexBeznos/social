class Stock < ActiveRecord::Base
  belongs_to :place

  has_attached_file :image,
                    :storage => :s3,
                    :path => "/images/stocks/:id/:style.:extension",
                    :url => ":s3_domain_url"

  validates :place_id, presence: true
  validates :url, :url => true
  validates_attachment :image, :presence => true,
                                :content_type => { :content_type => ["image/jpeg", "image/png", "image/gif"] }
end
