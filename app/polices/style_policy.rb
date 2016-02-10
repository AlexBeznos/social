class StylePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.franchisee?||user.general?
          scope.all
      end
    end
  end

  def permitted_attributes
    [:background,
     :text_color,
     :greating_color,
     :css,
     :network_icons ]
  end
end
