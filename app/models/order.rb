class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :menu_item

  default_scope { order('created_at DESC') }
  scope :pagination, -> (page_params) { page(page_params).per(3) }
end