require 'ext/string'

module ApplicationHelper
  def active_menu(menu_item)
    menu_item == controller_name ? 'active' : ''
  end

  def render_shared_navigation(navigation = true)
    render 'shared/navigation' if navigation == '' || navigation.to_bool
  end

  def fa_plus_minus(bool)
    if bool
      fa_icon 'plus'
    else
      fa_icon 'minus'
    end
  end
end
