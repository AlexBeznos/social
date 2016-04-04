module GowifiHelper
  def network_path(place, auth)
    if place.post_preview && auth.name != Auth::NETWORKS[:instagram].to_sym
      preview_path(place, auth_id: auth)
    else
      auth_path(place, auth)
    end
  end

  def auth_path(place, auth)
    "/auth/#{auth.name}?place=#{place.slug}"
  end

  def login_url(place, auth, customer)
    if place.loyalty_program && customer
      loyalty_url(place, auth: auth.id)
    else
      auth.redirect_url
    end
  end
end
