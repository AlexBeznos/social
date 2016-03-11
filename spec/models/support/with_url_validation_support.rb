RSpec.shared_examples 'with url validation for' do |attrs, klass|
  attrs = [attrs].flatten.map(&:to_sym)
  klass = described_class.to_s.underscore.to_sym unless klass

  attrs.each do |attr|
    it "valid #{attr}" do
      record = build_stubbed(klass, attr => Faker::Internet.url)

      expect(record).to be_valid
    end

    it "has invalid value" do
      record = build_stubbed(klass, attr => 'google.con')
      record.valid?
      expect(record.errors.messages[:url]).to include(I18n.t('models.errors.validations.wrong_link_format'))
    end
  end
end
