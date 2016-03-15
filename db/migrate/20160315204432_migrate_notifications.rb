class MigrateNotifications < ActiveRecord::Migration
  def self.up
    user_ids = User.where(group: "general").pluck(:id)

    Place.where(user_id: user_ids).each do |place|
      place.auths.each do |auth|
        Notification.create!(
          category: "Unapproved authentication",
          source: auth,
          user: place.user.franchisee
        )
      end
    end
  end

  def self.down
  end
end
