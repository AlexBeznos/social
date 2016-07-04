class GowifiAuth::PollController < GowifiAuthController
  before_action :find_place, only: :create

  def create
    @auth = Auth.find(poll_params[:id])
    answer = Answer.find(poll_params[:answer_ids])

    answer.increment!(:number_of_selections)

    redirect_to succed_auth_path(@place, @auth)
  rescue
    redirect_to :back, alert: I18n.t('wifi.poll_error')
  end

  private

  def poll_params
    params.require(:poll_auth).permit(:id, :answer_ids)
  end
end
