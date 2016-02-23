class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def permitted_attributes
    [:social_network_id, :message, :message_link, :image, :subscription]
  end
end
