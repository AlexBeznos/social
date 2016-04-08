class MenuItem < ActiveRecord::Base
  belongs_to :place
  has_and_belongs_to_many :orders

  mount_uploader :image, MenuItemUploader, mount_on: :image_file_name

  validates :name, :price, :place_id, presence: true
  validates :image,
            presence: true,
            file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif'] },
            file_size: { less_than_or_equal_to: 10.megabytes }

  scope :pagination, -> (page_params) { page(page_params).per(3) }
end
