module GowifiHelper
  def network_path(place, auth)
    if place.post_preview && auth.name != Auth::NETWORKS[:instagram].to_sym && auth.resource.posting_enabled?
      preview_path(place, auth: auth)
    else
      auth_path(place, auth)
    end
  end

  def auth_path(place, auth)
    "/auth/#{auth.name}?place=#{place.slug}"
  end
end
