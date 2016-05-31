def login(user)
  visit login_path
  fill_in :user_session_email, with: user.email
  fill_in :user_session_password, with: "qwerty"
  click_button "Войти"
end
