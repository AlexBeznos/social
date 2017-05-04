class GowifiSmsController < ApplicationController
  skip_after_action :verify_authorized

  layout 'gowifi'
  before_action :find_place, only: [:show, :create, :resend]
  before_action :find_sms, only: [:show, :resend]

  def show
    render 'gowifi/sms/show'
  end

  def create
    @sms = Profile.create_with_resource(sms_params, current_customer_session.customer).resource

    if @sms.persisted?
      GowifiSmsSendWorker.perform_async(@sms.id, @place.id)
      redirect_to gowifi_sms_confirmation_path(params[:slug], @sms)
    else
      redirect_to gowifi_place_path(@place), alert: @sms.errors.full_messages
    end
  end

  def resend
    @sms = SmsProfile.find(params[:id])
    GowifiSmsSendWorker.perform_async(@sms.id, @place.id)

    render nothing: true, status: :ok
  rescue ActiveRecord::RecordNotFound # NOTE: currenty not works because of rescue in application_controller
    render json: { error: t('errors.messages.not_found') },
           status: :not_acceptable
  end

  private

  def sms_params
    params.require(:sms_profile).permit(:phone, :provider)
  end

  def find_place
    @place = Place.find_by_slug(params[:slug])
  end

  def find_sms
    @sms = SmsProfile.find(params[:id])
  end
end
