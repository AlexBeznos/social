require 'rails_helper'

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "The #{factory_name} factory" do
    let(:factory) do
      if factory_name == :visit
        build_stubbed(:visit)
      else
        build(factory_name)
      end
    end

    it 'is valid' do
      p(factory.errors) unless factory.valid?
      expect(factory).to be_valid
    end
  end
end
