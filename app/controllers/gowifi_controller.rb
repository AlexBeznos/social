class GowifiController < ActionController::Base
  include Consumerable
  layout 'no-layout'
  before_action :find_place, only: :show
  before_action :find_customer, only: [:show, :omniauth]

  def show
    if @place && @place.active
      session[:slug] = @place.slug

      @networks = @place.get_networks

      if @networks.map{|network| network.name}.include?('vkontakte')
        @vk_message = get_message(@place, 'vkontakte')
      end
    else
      redirect_to '/404.html'
    end
  end

  def no_place
  end

  def omniauth
    @place = Place.find_by_slug(session[:slug])
    @message = get_message(@place, credentials['provider'])

    clear_session

    #post_advertisment
    deal_with_customer

    redirect_to 'http://172.16.16.1/login?user=P8uDratA&password=Tac4edrU'
  end

  def set_locale
    if I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
      I18n.locale = params[:locale]
    end

    redirect_to request.referrer
  end

  def feedback
    if params[:name] && params[:tel] && params[:email]
      BasicMailer.feedback(params[:name], params[:tel], params[:email]).deliver
      head :ok
    end
  end

  private

    def find_place
      @place = Place.find_by_slug(params[:slug])
    end

    def find_customer
      @customer = Customer.find(cookies.signed[:customer].to_i) if cookies.signed[:customer]
      @vk_uid = cookies.signed[:vk_uid]
    end

    def credentials
      request.env['omniauth.auth']
    end

    def clear_session
      session.delete(:slug)
    end

    def post_advertisment
      attrs = {:place => @place, :message => @message, :credentials => credentials}

      case credentials['provider']
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

    def deal_with_customer
      customer = find_or_create_costumer(credentials, @place, @customer)

      unless @customer
        cookies.permanent.signed[:customer] = customer.id
      end
    end

end
