class MenuItem < ActiveRecord::Base
  belongs_to :place
  has_many :orders
  has_many :customers, through: :orders

  validates :name, :price, :place_id, presence: true

  def create_order(reputation, customer)
    if reputation.score >= self.price
      reputation.update(score: reputation.score - self.price)
      customer.menu_items << self
    else
      false
    end
  end
end
