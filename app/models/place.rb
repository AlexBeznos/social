require 'ext/string'
require 'cyrillizer'

class Place < ActiveRecord::Base
  has_unique_slug :subject => Proc.new {|place| "#{place.name.to_lat.urlize({:convert_spaces => true})}"}

  has_many :messages, :dependent => :destroy
  belongs_to :user

  before_validation :set_password, if: 'enter_by_password'

  validates :name, presence: true
  validates :password, presence: true, if: 'enter_by_password'


  def set_password
    if self.id && self.password == ''
      place = Place.find(self.id)
      self.password = place.password if place
    end
  end

  def get_networks
    networks = []
    Message.networks.keys.each do |key|
      if self.messages.where("network = ? and active = true", Message.networks[key.to_sym]).any?
        networks.push(key)
      end
    end
    
    networks
  end
end
