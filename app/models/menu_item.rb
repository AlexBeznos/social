class MenuItem < ActiveRecord::Base
  belongs_to :place
  has_and_belongs_to_many :orders

  mount_uploader :image, MenuItemUploader, mount_on: :image_file_name

  validates :name, :price, :place_id, presence: true
  validates :image,
            presence: true,
            file_content_type: { allow: ["image/jpeg", "image/png", "image/gif"] },
            file_size: { in: 11.kilobytes..10.megabytes }

  scope :pagination, -> (page_params) { page(page_params).per(3) }

  after_destroy :disable_place_scratchcard

  private

  def disable_place_scratchcard
    if place.menu_items.empty?
      place.update(scratchcard: false)
    end
  end

end
