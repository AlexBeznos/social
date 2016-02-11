class StylePolicy < ApplicationPolicy
  
  def permitted_attributes
    [:background,
     :text_color,
     :greating_color,
     :css,
     :network_icons ]
  end
end
