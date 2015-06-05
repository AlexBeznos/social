class VkontakteController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  def upload
    @photo = VkService.upload_picture(params[:vk_url], params[:image_url])
    @hash = {
      :hash => @photo['hash'],
      :server => @photo['server'],
      :photo => @photo['photo']
    }

    render json: @hash
  end
end
