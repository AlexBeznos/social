class GeneralAuth < ActiveRecord::Base
  self.abstract_class = true

  NETWORKS = %w(
    vkontakte
    twitter
    facebook
  )

  validates :redirect_url, presence: true
end
