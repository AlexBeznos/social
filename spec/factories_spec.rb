require 'rails_helper'

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "The #{factory_name} factory" do
    let(:factory) { build(factory_name) }

    it 'is valid' do
      p(factory.errors) unless factory.valid?
      expect(factory).to be_valid
    end
  end
end
