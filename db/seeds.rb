User.create(email: 'a@u.com', password: 'qwerty', password_confirmation: 'qwerty')
User.create(email: 'b@u.com', password: 'qwerty', password_confirmation: 'qwerty')
User.create(email: 'c@u.com', password: 'qwerty', password_confirmation: 'qwerty')
User.create(email: 'd@u.com', password: 'qwerty', password_confirmation: 'qwerty')
User.create(email: 'alex@u.com', password: 'qwerty', password_confirmation: 'qwerty', group: 'admin')
User.create(email: 'bbking@u.com', password: 'qwerty', password_confirmation: 'qwerty', group: 'admin')


# Do not change order
SocialNetwork.create(name: 'vkontakte')
SocialNetwork.create(name: 'facebook')
SocialNetwork.create(name: 'instagram')
SocialNetwork.create(name: 'twitter')
