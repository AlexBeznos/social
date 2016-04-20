class MigrateStock < ActiveRecord::Migration
  def self.up
    Stock.find_each do |stock|
      stock_day = stock.day

      if stock_day == "в любой день"
        day_numbers = (0..6).to_a
      else
        day = Date::DAYNAMES.index(stock_day)
        day_numbers = [day]
      end

      stock.update_attribute(:days, day_numbers)
    end
  end

  def self.down
  end
end
