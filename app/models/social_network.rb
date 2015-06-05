class SocialNetwork < ActiveRecord::Base
  has_many :messages
  has_many :customers

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
