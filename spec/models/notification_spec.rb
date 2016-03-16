require "rails_helper"

RSpec.describe Notification do
  it{ is_expected.to belong_to(:user).conditions(group: "franchisee")}
  it{ is_expected.to belong_to(:source) }
  it{ is_expected.to validate_presence_of :category }
end
