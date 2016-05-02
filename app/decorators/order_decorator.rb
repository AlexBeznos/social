class OrderDecorator
  def self.decorate_multiple(orders)
    orders.map do |order|
      self.new(order)
    end
  end

  def initialize(order)
    @order = order
  end

  def time
    "Time"
  end

  def price
    "Price"
  end

  def items_received
    "Received"
  end

  def customer_full_name
    "Newotk id"
  end

  def customer_score
    "Customer score"
  end

end
