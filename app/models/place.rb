require 'ext/string'
require 'cyrillizer'

class Place < ActiveRecord::Base
  has_unique_slug :subject => Proc.new {|place| "#{place.name.to_lat.urlize({:convert_spaces => true})}"}

  has_attached_file :mobile_image,
                    :storage => :s3,
                    :path => "/images/backgrounds/mobile/:id/:style.:extension",
                    :url => ":s3_domain_url"

  has_attached_file :tablet_image,
                    :storage => :s3,
                    :path => "/images/backgrounds/tablet/:id/:style.:extension",
                    :url => ":s3_domain_url"

  has_attached_file :desktop_image,
                    :storage => :s3,
                    :path => "/images/backgrounds/desktop/:id/:style.:extension",
                    :url => ":s3_domain_url"

  has_many :messages, :dependent => :destroy
  belongs_to :user

  before_validation :set_password, if: 'enter_by_password'

  validates :name, presence: true
  validates :password, presence: true, if: 'enter_by_password'
  validates_attachment :mobile_image,
                       :tablet_image,
                       :desktop_image,
                       :presence => true,
                       :content_type => { :content_type => ["image/jpeg", "image/png", "image/gif"] },
                       if: 'background_active'

  def set_password
    if self.id && self.password == ''
      place = Place.find(self.id)
      self.password = place.password if place
    end
  end

  def get_networks
    networks = []
    SocialNetwork.all.each do |network|
      if self.messages.where("social_network_id = ? and active = true", network.id).any?
        networks.push(network)
      end
    end

    networks
  end
end
