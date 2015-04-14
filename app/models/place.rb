require 'ext/string'
require 'cyrillizer'

class Place < ActiveRecord::Base
  attr_accessor :changable_slug
  belongs_to :user

  before_validation :gen_slug

  def gen_slug
    if self.changable_slug
      self.slug = self.changable_slug
    else
      self.slug = self.name.to_lat.urlize({:convert_spaces => true})
    end
  end
end
