class GowifiSmsController < ApplicationController
  skip_after_action :verify_authorized

  layout 'gowifi'
  before_action :find_place, only: [:show, :create]
  before_action :find_sms, only: [:show]

  def show
    render 'gowifi/sms/show'
  end

  def create
    @gowifi_sms = GowifiSms.new(gowifi_sms_params)

    if @gowifi_sms.save
      redirect_to gowifi_sms_confirmation_path(params[:slug], @gowifi_sms)
    else
      redirect_to gowifi_place_path(@place), alert: @gowifi_sms.errors.messages.first.last.first
    end
  end

  def resend
    @gowifi_sms = GowifiSms.find(params[:id])
    @gowifi_sms.resend_sms

    render nothing: true, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: t('errors.messages.not_found') },
           status: :not_acceptable
  end

  private
  def gowifi_sms_params
    params.require(:gowifi_sms).permit(:phone).tap do |param|
      param[:place_id] = Place.find_by_slug(params[:slug]).id
    end
  end

  def find_place
    @place = Place.find_by_slug(params[:slug])
  end

  def find_sms
    @sms = GowifiSms.find(params[:id])
  end
end
