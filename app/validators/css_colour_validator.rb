class CssColourValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return false unless value
    record.errors[attribute] << (options[:message] || I18n.t('errors.not_valid_css_color')) unless ::HexadecimalColourValidator.matches?(value) or ::WebSafeColourValidator.matches?(value)
  end
end
