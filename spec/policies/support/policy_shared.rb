RSpec.shared_examples "visitor" do
  context "for visitor" do
    let(:author_error){ Pundit::NotAuthorizedError }

    it{expect{described_class.new(nil,record)}.to raise_error(author_error)}
  end
end
