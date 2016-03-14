class MigratePollsToPollAuth < ActiveRecord::Migration
  def self.up
    place_ids = Place.where(polls_active: true).pluck(:id)

    PollAuth.where(place_id: place_ids).each do |poll|
      Auth.create(
        resource: poll,
        redirect_url: Place.find(poll.place_id).redirect_url
      )
    end
  end

  def self.down
  end
end
