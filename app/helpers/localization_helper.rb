module LocalizationHelper
  def localization_links_in_place
    to_link = lambda { |l| link_to(l, url_for(lang: l)) }
    localization_links_by_path to_link
  end

  def localization_links
    to_link = lambda { |l| link_to(l, set_locale_path(l)) }
    localization_links_by_path to_link
  end

  private

  def localization_links_by_path(to_link)
    locals = I18n.available_locales
    links  = locals.map { |l| to_link.call(l) }

    raw links.join(' | ')
  end

  def datepicker_locale_name
    locale = I18n.locale

    if locale == :en
      "en-GB"
    elsif locale == :am
      "hy"
    elsif locale == :ua
      "uk"
    else
      locale.to_s
    end
  end
end
