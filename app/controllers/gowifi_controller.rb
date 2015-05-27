class GowifiController < ActionController::Base
  layout 'no-layout'
  before_action :find_place, only: :show

  def show
    if @place && @place.active
      session[:slug] = @place.slug

      @networks = @place.get_networks
    else
      redirect_to '/404.html'
    end
  end

  def no_place
  end

  def omniauth
    place = Place.find_by_slug(session[:slug])
    clear_session
    redirect_to post_advertisment_and_get_redirect_url(place)
  end

  def set_locale
    if I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
      I18n.locale = params[:locale]
    end

    redirect_to request.referrer
  end

  private

    def find_place
      @place = Place.find_by_slug(params[:slug])
    end

    def credentials
      request.env['omniauth.auth']
    end

    def clear_session
      session.delete(:state)
      session.delete(:slug)
    end

    def post_advertisment_and_get_redirect_url(place)
      attrs = {:place => place, :credentials => credentials}

      return  case credentials['provider']
              when 'twitter'
                 TwitterService.new(attrs).advertise
              when 'instagram'
                 InstagramService.new(attrs).advertise
              when 'vkontakte'
                 VkService.new(attrs).advertise
              when 'facebook'
                 FacebookService.new(attrs).advertise
              end
  end
end
