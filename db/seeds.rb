# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first


20.times do
    Country.create(name: Faker:: Address.City, position: Faker:: city, flag: "test" , currency: Faker:: Currency.name )
end
puts "Country has been created"


20.times do 
  City.create(name: country:Country.all.sample, address:Faker::Address.city ,climat:"test",description:"test",timezone:"test",traditions:"test")
end 
puts "City has been created"

20.times do
    Activity.create(name:Faker ::name, address: , price:, description:, picture:, cities_id: ,activities_category: )
end

    #Activity.create(name:)
    #Cart.create(name:)
    #User.create(name:)
    #Activity_categories.create(name:)
