class Banner < ActiveRecord::Base
  has_attached_file :content,
                    :storage => :s3,
                    :path => "/banners/:id/:style.:extension",
                    :url => ":s3_domain_url"
  belongs_to :place
  validates :place_id, :attachment, :name, presence: true 
end
