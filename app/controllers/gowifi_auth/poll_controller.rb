class GowifiAuth::PollController < GowifiAuthController
  before_action :find_place, only: :create
  after_action :ahoy_track_visit, only: :create

  def create
    if params[:poll_auth]
      auth = Auth.find(poll_params[:id])
      answer = Answer.find(poll_params[:answer_ids])

      if answer.increment!(:number_of_selections)
        redirect_to succed_auth_path(@place, auth)
      else
        redirect_to gowifi_place_path(@place)
      end
    else
      redirect_to :back, alert: I18n.t('wifi.poll_error')
    end
  end

  private

  def poll_params
    params.require(:poll_auth).permit(:id, :answer_ids)
  end
end
