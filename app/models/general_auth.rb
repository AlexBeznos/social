class GeneralAuth < ActiveRecord::Base
  self.abstract_class = true

  validates :redirect_url, presence: true
end
