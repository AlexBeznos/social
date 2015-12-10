class GowifiSmsController < ApplicationController
  def create
    @gowifi_sms = GowifiSms.new(gowifi_sms_params)

    if @gowifi_sms.save
      render json: { id: @gowifi_sms.id }, status: :ok
    else
      render json: { error: @gowifi_sms.errors.messages.first.join(' ') },
             status: :not_acceptable
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
end
