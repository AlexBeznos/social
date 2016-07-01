require 'rails_helper'

describe "Tomorror night." do

  context "first ctx" do
    before(:each)do
      p "sosi pisos"
    end
    it "suka" do
      expect(true).to eq(true)
    end
  end

  context "second ctx" do
    it "suka" do
      expect(true).to eq(true)
    end
  end
end
