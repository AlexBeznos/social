class Banner < ActiveRecord::Base
  mount_uploader :content, BannerUploader, mount_on: :content_file_name

  belongs_to :place

  validates :place_id, :name, :content, presence: true
  validates :content, file_content_type: { allow: ["image/jpeg", "image/png", "image/gif","video/mp4", "video/webm"] },
                      file_size: { in: 11.kilobytes..30.megabytes }
end
