class MessagePolicy < ApplicationPolicy
  def permitted_attributes
    [
      :social_network_id,
      :message,
      :message_link,
      :image,
      :subscription
    ]
  end
end
