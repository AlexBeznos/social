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
      push_image = image_tag stock.image.url, class: 'offer'
      stock.url.blank? ? push_image : link_to(push_image, stock.url)
    end
  end

  def approved? (auth)
    if Auth::NETWORKS.keys.include?(auth.name)
      if auth.notification
        {
          text: "unapproved",
          style: "danger"
        }
      else
        {
          text: "approved",
          style: "success"
        }
      end
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
end
