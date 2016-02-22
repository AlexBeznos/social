class User < ActiveRecord::Base
  acts_as_authentic

  default_scope { order(:id) }

  has_many :place_groups, :dependent => :destroy
  has_many :places, :dependent => :destroy
  has_many :place_owners, class_name: 'User', foreign_key: :user_id
  belongs_to :franchisee, class_name: 'User', foreign_key: :user_id

  validates :first_name, :last_name, :phone, presence: true
  validates :user_id, presence: true, if: 'group.to_sym == :general'
  validates :phone, length: { minimum: 10, maximum: 20 },
                    phone: true

  enum group: [:general, :franchisee, :admin]

  def get_all_places
    if self.general?
      return self.places
    else
      places = []
      places.concat(self.places)

      self.place_owners.includes(:places).each do |owner|
        places.concat(owner.places)
      end

      places.uniq
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
