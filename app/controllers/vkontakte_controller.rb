class VkontakteController < ApplicationController
  include Consumerable
  protect_from_forgery with: :null_session
  respond_to :json

  def upload
    @photo = VkService.upload_picture(params[:vk_url], params[:message])


    @hash = {
      :hash => @photo['hash'],
      :server => @photo['server'],
      :photo => @photo['photo']
    }

    render json: @hash
  end

  def save
    @customer = Customer.find(params[:customer]) if params[:customer] != 'none'
    @place = Place.find(params[:place_id])
    credentials = params[:credentials]
    credentials['provider'] = 'vkontakte'

    customer = find_or_create_costumer(credentials, @place, @customer ? @customer : false)

    render json: {:link => 'http://172.16.16.1/login?user=P8uDratA&password=Tac4edrU', :customer => customer.id}

  end
end
