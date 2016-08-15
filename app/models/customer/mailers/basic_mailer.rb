class BasicMailer < ActionMailer::Base
  default from: "GoFriends WiFi <info@gofriends.com.ua>"

  def feedback(name, tel, email)
    @name, @tel, @email = name, tel, email
    mail to: 'info@gofriends.com.ua', subject: "Feedback from gofriends.com.ua landing"
  end
end
