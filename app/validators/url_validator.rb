class UrlValidator < ActiveModel::EachValidator

  def initialize(options)
    options.reverse_merge!(:schemes => %w(http https))
    options.reverse_merge!(:no_local => false)

    super(options)
  end

  def validate_each(record, attribute, value)
    schemes = [*options.fetch(:schemes)].map(&:to_s)
    begin
      uri = Addressable::URI.parse(value)
      unless uri && uri.host && schemes.include?(uri.scheme) && (!options.fetch(:no_local) || uri.host.include?('.'))
        record.errors.add(attribute, I18n.t('models.errors.validations.wrong_link_format'), value: value)
      end
    rescue Addressable::URI::InvalidURIError
      record.errors.add(attribute, I18n.t('models.errors.validations.wrong_link_format'), value: value)
    end
  end
end
