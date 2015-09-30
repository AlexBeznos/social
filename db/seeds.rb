u = User.create(email: 'alex@u.com', password: 'qwerty', password_confirmation: 'qwerty', first_name: 'Alex', last_name: 'Beznos', phone: '+380953834738', group: 'admin')
User.create(email: 'bbking@u.com', password: 'qwerty', password_confirmation: 'qwerty', first_name: 'Alex', last_name: 'Beznos', phone: '+380953834738', group: 'admin')

User.create(email: 'a@u.com', password: 'qwerty', password_confirmation: 'qwerty', first_name: 'Alex', phone: '+380953834738', last_name: 'Beznos', user_id: u.id)
User.create(email: 'b@u.com', password: 'qwerty', password_confirmation: 'qwerty', first_name: 'Alex', phone: '+380953834738', last_name: 'Beznos', user_id: u.id)
User.create(email: 'c@u.com', password: 'qwerty', password_confirmation: 'qwerty', first_name: 'Alex', phone: '+380953834738', last_name: 'Beznos', user_id: u.id)
User.create(email: 'd@u.com', password: 'qwerty', password_confirmation: 'qwerty', first_name: 'Alex', phone: '+380953834738', last_name: 'Beznos', user_id: u.id)


(1..30).each do |i|
  bday = Faker::Date.between(10.years.ago, Date.today) 
  name  = Faker::Name.first_name
  lname  = Faker::Name.last_name
  id = i
  Customer.create(first_name: name, last_name: lname, age: 20, birthday: bday,
                  city: 'Moskow', country: 'Russia', social_network_id: 1)
  Customer::NetworkProfile.create(social_network_id: 1, customer_id: id, uid: id)
  Customer::Visit.create(customer_network_profile_id: id, place_id: 1, customer_id: id)
end

# Do not change order
SocialNetwork.create(name: 'vkontakte')
SocialNetwork.create(name: 'facebook')
SocialNetwork.create(name: 'instagram')
SocialNetwork.create(name: 'twitter')
