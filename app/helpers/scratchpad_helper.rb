module ScratchpadHelper
  def succeed_scratch_path(place, auth)
      url = if place.loyalty_program && cookies[:customer]
        loyalty_url(place, auth: auth.id)
      else
        auth.redirect_url
      end

      wifi_login_path(place, url)
    end
end
