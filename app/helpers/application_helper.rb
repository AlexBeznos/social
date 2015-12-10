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

  def fa_plus_minus(bool)
    fa_icon( bool ? 'plus' : 'minus' )
  end
end
