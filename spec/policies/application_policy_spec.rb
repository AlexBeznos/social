require 'rails_helper'

RSpec.describe ApplicationPolicy do
  let(:user){ create :user_general }
  let(:anothers_record){ create :user_admin }

  describe "initialize" do
    context "user try to access to another`s record" do
      it "raises an not authorized error" do
        expect do
          Pundit.policy(user, anothers_record).update?
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
