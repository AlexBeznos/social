class StockPolicy < ApplicationPolicy
  

  def permitted_attributes
    [:url, :image, :day]
  end

end
