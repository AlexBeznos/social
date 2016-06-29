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

  def destroy?
    user.admin?
  end

  def permitted_attributes
    params = [
      :background,
      :text_color,
      :greating_color,
      :css,
      :network_icons,
      :line_colors,
      :facebook_icon,
      :twitter_icon,
      :vkontakte_icon,
      :instagram_icon
    ]

    return params + [:js] if user.admin?
    params
  end
end
