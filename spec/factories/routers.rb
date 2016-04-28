FactoryGirl.define do
  factory :router do
    association :place
    ovpn { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'routers', 'ovpn.xml')) }
    login_page { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'routers', 'login.html')) }
    settings { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'routers', 'settings.zip')) }
  end

end
