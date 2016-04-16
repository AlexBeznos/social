require "rails_helper"

describe "Place wifi login page" do
  let(:place){
    create :place
  }

  describe "Social auths " do
    context "with default styles" do
      include_examples "with social icons"
    end
  end

  describe "Poll auth" do
    context "with default styles" do
      include_examples "with proper polls"
    end
  end

  describe "Password auth" do
    context "with default styles" do
      include_examples "with proper password"
    end
  end
end
