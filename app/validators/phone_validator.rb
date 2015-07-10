class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return false unless value
    record.errors[attribute] << (options[:message] || I18n.t('models.errors.validations.wrong_phone_number')) unless self.class.matches?(value)
  end

  def self.matches?(value)
    return false unless value
    /\A(?:(?:\(?(?:00|\+)([1-4]\d\d|[1-9]\d?)\)?)?[\-\.\/]?)?((?:\(?\d{1,}\)?[\-\.\/]?){0,})?\z/.match(value).nil? ? false : true
  end
end