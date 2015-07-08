class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return false unless value
    record.errors[attribute] << (options[:message] || I18n.t('errors.wrong_link_format')) unless self.class.matches?(value)
  end

  def self.matches?(value)
    return false unless value
    /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix.match(value).nil? ? false : true
  end
end