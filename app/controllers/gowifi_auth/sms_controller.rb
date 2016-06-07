class GowifiAuth::SmsController < GowifiAuthController
  before_action :find_place, only: :create
  after_action :ahoy_track_visit, only: :create

  def create
    sms = SmsProfile.find_by(code: params[:code])
    auth = @place.auths.active.find_by({ resource_type: SmsAuth, step: Auth.steps[session[:auth_step]] })

    if sms && sms.update(used: true)
      Customer::Visit.create(
        place: @place,
        account_id: sms.profile.resource_id,
        account_type: sms.profile.resource_type,
        customer: sms.profile.customer
      )
      redirect_to succed_auth_path(@place, auth)
    else
      redirect_to gowifi_sms_confirmation_path(@place, params[:id]), alert: I18n.t('wifi.sms_try_more')
    end
  end
end
