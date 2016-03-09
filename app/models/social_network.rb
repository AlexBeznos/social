class SocialNetwork < ActiveRecord::Base
  has_many :customers

  scope :by_name, -> (name) { find_by(name: name) }

  validates :name, :presence => true, :uniqueness => true

  def font_awesome_name
    case name
    when 'vkontakte'
      'vk'
    else
      name
    end
  end
end
