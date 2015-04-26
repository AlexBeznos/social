class VkService
  include Advertisable
  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @credentials = hash[:credentials]
  end

  def advertise
    message = get_message(@place, @credentials['provider'])

    message.redirect_link
  end
end
