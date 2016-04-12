module StylesHelper
  def notification_style(auth)
    state = auth.aasm.current_state

    case state
    when :pending
      "text-warning"
    when :unapproved
      "text-danger"
    when :approved
      "text-success"
    end
  end

  def background_style(place)
    background_path = if place.try(:style).try(:background).present?
                        place.style.background.url
                      else
                        image_url("wifi/default/bg.jpg")
                      end

    <<-FIN
      background: url( #{background_path} ) no-repeat center;
      background-attachment: fixed;
      background-size: cover;
      FIN
  end

end
