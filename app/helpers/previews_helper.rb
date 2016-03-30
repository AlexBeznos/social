module PreviewsHelper
  def auth_url(auth, place)
    "/auth/#{auth.name}?place=#{place.slug}"
  end
end
