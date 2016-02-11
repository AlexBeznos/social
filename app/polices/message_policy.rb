class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.franchisee?
        scope.all
      elsif user.general? && user.id
        scope.where(with_message_type: 'Place')
      elsif user.admin?
        scope.all
      end
    end
  end

  def permitted_attributes
    [:social_network_id, :message, :message_link, :image, :subscription]
  end
end
