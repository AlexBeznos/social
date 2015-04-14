require 'ext/string'
require 'cyrillizer'

class Place < ActiveRecord::Base
  attr_accessor :changable_slug
  belongs_to :user

  before_validation :gen_slug
  before_validation :set_password, if: 'enter_by_password'

  validates :name, presence: true
  validates :password, presence: true, if: 'enter_by_password'
  validate :check_slug

  def check_slug
    if Place.where(slug: self.slug).any? && self != Place.find_by(slug: self.slug)
      self.errors.add(:changable_slug, 'place with such slug already exists')
    end
  end

  def gen_slug
    if self.changable_slug != ''
      self.slug = self.changable_slug.to_lat.urlize({:convert_spaces => true})
    else
      self.slug = self.name.to_lat.urlize({:convert_spaces => true})
    end
  end

  def set_password
    if self.id && self.password == ''
      place = Place.find(self.id)
      self.password = place.password if place
    end
  end
end
