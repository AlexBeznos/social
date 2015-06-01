class User < ActiveRecord::Base
  acts_as_authentic

  has_many :places, :dependent => :destroy
  has_many :place_owners, class_name: 'User', foreign_key: :user_id
  belongs_to :franchisee, class_name: 'User', foreign_key: :user_id

  validate :user, presence: true, if: 'group.to_sym == :general'

  enum group: [:general, :franchisee, :admin]

  def get_all_places
    if self.general?
      return self.places
    else
      places = self.places

      self.place_owners.includes(:places).each do |owner|
        places.concat(owner.places)
      end

      places.uniq
    end
  end
end
