class Order < ActiveRecord::Base
  extend TimeQueries

  belongs_to :customer
  belongs_to :place
  has_and_belongs_to_many :menu_items

  default_scope { order('created_at DESC') }
  scope :pagination, -> (page_params) { page(page_params).per(3) }

  def add_menu_item(reputation, menu_item)
    if reputation.score >= menu_item.price
      reputation.update(score: reputation.score - menu_item.price)
      self.menu_items << menu_item
    else
      false
    end
  end
end
