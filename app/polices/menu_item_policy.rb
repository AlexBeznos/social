class MenuItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.general?
        scope.where(place_id: user.places.pluck(:id))
      elsif user.franchisee?
        scope.where(place_id:  all_owners_places_ids)
      elsif user.admin?
        scope.all
      end
    end
  end

  def  permitted_attributes
    [
      :name,
      :price,
      :description,
      :image
    ]
  end
end
