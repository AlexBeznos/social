class BasicController < ApplicationController
  skip_after_action :verify_authorized

  def set_locale
    if I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
      I18n.locale = params[:locale]
    end
    redirect = request.referrer

    redirect_to  redirect ||= root_path
  end

  def feedback
    if params[:name] && params[:tel] && params[:email]
      BasicMailer.feedback(params[:name], params[:tel], params[:email]).deliver
      head :ok
    end
  end
end
