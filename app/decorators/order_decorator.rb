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
    @order.created_at.strftime("%H:%M %d.%m.%y")
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

  def customer_full_name
    customer_network_profiles.first.full_name
  end

  def customer_network_profiles
    @order.customer.profiles.select { |profile| profile.postable? }
  end

  private

  def method_missing(m, *args, &block)
    @order.send(m, *args, &block)
  end

end
