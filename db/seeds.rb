# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Users
require 'faker'

locations = [{street_address: "643 Fifth Ave",
              city: "San Diego",
              state: "CA",
              zip: "92101"},
             {street_address: "600 Fifth Ave",
              city: "San Diego",
              state: "CA",
              zip: "92101"},
             {street_address: "770 Fifth Ave",
              city: "San Diego",
              state: "CA",
              zip: "92101"}]

3.times do |n|
  user = User.create(first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.email,
              password: "123456",
              phone: "123-456-7890")
  user.locations.create(locations[n])
end

pand0 = User.create(first_name: 'p',
            last_name: 'p',
            email: 'p@p',
            password: "123456",
            phone: "123-456-7890")

pand0.locations.create({
  street_address: "6475 Antigua Blvd",
  city: "San Diego",
  state: "CA",
  zip: "92124"
  })

Location.create({street_address: "644 Fifth Ave",
                city: "San Diego",
                state: "CA",
                zip: "92101",
                user_id: 7})


# Locations

# User.all.each do |user|
#   user.locations.create(street_address: Faker::Address.street_address,
#                         city: Faker::Address.city,
#                         state: Faker::Address.state_abbr,
#                         zip: Faker::Address.zip)
# end

# Spaces

Location.all.each do |location|
  location.spaces.create(space_active: 1, price: 3, size: 'large')
  location.spaces.create(space_active: 1, price: 2)
  location.spaces.create(space_active: 1, price: 5, size: 'RV')
end

4.times do |n|
  ChatRoom.create(title: "Chat with: #{Location.find(n+1).owner.first_name}", location_id: Location.find(n+1).id, user_id: 1)
end


