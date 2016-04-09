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
    if place.try(:style).try(:background).present?
      <<-FIN
        background: url( #{place.style.background.url} ) no-repeat center;
        background-attachment: fixed;
        background-size: cover;
        FIN
    else
      <<-FIN
          background: url( #{image_path("wifi/default/bg.jpg")}) no-repeat center;
          background-attachment: fixed;
          background-size: cover;
        FIN
    end
  end

end
