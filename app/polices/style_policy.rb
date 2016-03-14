class StylePolicy < ApplicationPolicy
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

  def permitted_attributes
    [
      :background,
      :text_color,
      :greating_color,
      :css,
      :network_icons
    ]
  end
end
