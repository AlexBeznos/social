class BannersController < ApplicationController
  load_and_authorize_resource :place, find_by: :slug
  load_and_authorize_resource :banner, through: :place

  before_action :set_banner, only: [:edit, :update, :destroy]


  def index
    @banners = @place.banners
  end

  def new
    @banner = @place.banners.new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_banner
      @banner = Banner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poll_params
      params.require(:banner).permit(:name, :attachment)
    end
  
end
