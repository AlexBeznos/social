require 'ext/string'

module ApplicationHelper
  def active_menu(menu_item)
    menu_item == controller_name ? 'active' : ''
  end

  def render_shared_navigation(navigation = true)
    render 'shared/navigation' if navigation == '' || navigation.to_bool
  end

  def render_stock_image(stock)
    push_image = image_tag stock.image.url, class: 'offer'

    if stock.url != ''
      link_to push_image, stock.url
    else
      push_image
    end
  end

  def fa_plus_minus(bool)
    fa_icon( bool ? 'plus' : 'minus' )
  end

  def link_to_function(name, *args, &block)
     html_options = args.extract_options!.symbolize_keys

     function = block_given? ? update_page(&block) : args[0] || ''
     onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
     href = html_options[:href] || '#'

     content_tag(:a, name, html_options.merge(:href => href, :onclick => onclick))
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
    

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end

end
