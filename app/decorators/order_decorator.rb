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
    @order.created_at.to_formatted_s(:time)
  end

  def price
    @order.menu_items.inject(0){|sum, item| sum + item.price }
  end

  def items_received
    @order.menu_items.map(&:name).join(" ")
  end

  def customer_score
    Customer::Reputation.where(
                          customer: @order.customer,
                          place: @order.place
                        ).first.score
  end

  private

  def method_missing(m, *args, &block)
    @order.send(m, *args, &block)
  end

end
