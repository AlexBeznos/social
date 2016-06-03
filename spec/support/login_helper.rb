def login(user)
<<<<<<< HEAD
  visit Rails.application.routes.url_helpers.login_path
=======
  visit "/login"
>>>>>>> ddb9eb489b7a9a1d4a92031f52d10650fdb3d14f
  fill_in("user_session_email", with: user.email)
  fill_in("user_session_password", with: user.password)
  find("input[type='submit']").click
end
