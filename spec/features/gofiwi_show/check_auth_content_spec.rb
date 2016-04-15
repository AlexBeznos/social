require "rails_helper"

describe "Place wifi login page" do
  let(:place){
    create :place
  }

  describe "Social auths " do
    include_examples "with social icons"
  end

  describe "Poll auth" do

  end

  describe "Password auth" do

  end
end
