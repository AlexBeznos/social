require 'ext/string'

module ApplicationHelper
  def active_menu(menu_item)
    menu_item == controller_name ? 'active' : ''
  end

  def render_shared_navigation(navigation = true)
    render 'shared/navigation' if navigation.to_bool
  end
end
