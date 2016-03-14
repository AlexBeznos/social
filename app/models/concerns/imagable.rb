module Imagable
  def to_full_url(path)
    return "http://localhost:3000#{path}" if Rails.env.development?
    return "http:#{path}"                 if Rails.env.production?
  end
end
