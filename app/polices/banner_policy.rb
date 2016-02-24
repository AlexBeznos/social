class BannerPolicy < ApplicationPolicy

  def permitted_attributes
    [:name, :content]
  end
end
