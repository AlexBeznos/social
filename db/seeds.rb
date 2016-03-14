u = User.create(email: 'alex@u.com', password: 'qwerty', password_confirmation: 'qwerty', first_name: 'Alex', last_name: 'Beznos', phone: '+380953834738', group: 'franchisee' )
a = User.create(email: 'bbking@u.com', password: 'qwerty', password_confirmation: 'qwerty', first_name: 'Alex', last_name: 'Beznos', phone: '+380953834738', group: 'admin')

User.create(email: 'a@u.com', password: 'qwerty', password_confirmation: 'qwerty', first_name: 'Alex', phone: '+380953834738', last_name: 'Beznos', user_id: a.id)
User.create(email: 'b@u.com', password: 'qwerty', password_confirmation: 'qwerty', first_name: 'Alex', phone: '+380953834738', last_name: 'Beznos', user_id: u.id)
User.create(email: 'c@u.com', password: 'qwerty', password_confirmation: 'qwerty', first_name: 'Alex', phone: '+380953834738', last_name: 'Beznos', user_id: u.id)
User.create(email: 'd@u.com', password: 'qwerty', password_confirmation: 'qwerty', first_name: 'Alex', phone: '+380953834738', last_name: 'Beznos', user_id: u.id)


SocialNetwork.create(name: 'vkontakte')
SocialNetwork.create(name: 'facebook')
SocialNetwork.create(name: 'instagram')
SocialNetwork.create(name: 'twitter')
