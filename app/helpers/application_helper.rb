require 'ext/string'

module ApplicationHelper
  def active_menu(menu_item)
    menu_item == controller_name ? 'active' : ''
  end

  def render_shared_navigation(navigation = true)
    render 'shared/navigation' if navigation == '' || navigation.to_bool
  end

  def render_stock_image(place)
    stock = place.get_proper_stock

    if place.stocks_active && stock
      image_tag stock.image.url, class: 'offer'
    end
  end

  def fa_plus_minus(bool)
    fa_icon( bool ? 'plus' : 'minus' )
  end

  def localization_links
    to_link = lambda { |l| link_to(l, set_locale_path(l)) }
    locals    = I18n.available_locales
    links     = locals.map { |l| to_link.call(l) }

    raw links.join(' | ')
  end

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

  def notification_title(user)
    if user.franchisee?
      t(:modified_authentications, scope: "models.notifications")
    elsif user.general?
      t(:unapproved_authentications, scope: "models.notifications")
    end
  end

end
