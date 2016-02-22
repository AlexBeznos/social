class MenuItemPolicy < ApplicationPolicy
  def  permitted_attributes
    [
      :name,
      :price,
      :description,
      :image
    ]
  end
end
