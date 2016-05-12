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

  def include_i18n_calendar_javascript
    content_for :head do
      javascript_include_tag case I18n.locale
        when :en then "jquery.ui.datepicker-en-GB.js"
        when :ru then "jquery.ui.datepicker-pt-BR.js"
        else raise ArgumentError, "Locale error"
      end
    end
  end
end
