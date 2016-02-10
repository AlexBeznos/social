class Banner < ActiveRecord::Base
  # has_attached_file :content,
  #                   :storage => :s3,
  #                   :path => "/banners/:id/:style.:extension",
                    # :url => ":s3_domain_url"
  mount_uploader :content, ContentUploader, mount_on: :content_file_name

  belongs_to :place
  validates :place_id, :name, presence: true
  # validates_attachment :content, :presence => true,
  #                               size: { in: 11.kilobytes..5.megabytes },
  #                               :content_type => { :content_type => ["image/jpeg", "image/png", "image/gif",
  #                                                                     "video/mp4", "video/webm"] }
end
