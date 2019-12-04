
puts "destruction de l'ancienne BDD en cours"
Country.destroy_all
City.destroy_all
ActivitiesCategory.destroy_all
Activity.destroy_all
User.destroy_all
Cart.destroy_all
Order.destroy_all
Ticket.destroy_all

puts "destruction terminée"

puts "Génération de la nouvelle BDD en cours"
puts "Extraction du CSV en cours"
file = CSV.read("activities_seoul.csv")
puts "Extraction terminée"

puts "Génération des activités en cours" 

5.times do
    Country.create(name: Faker::Address.country, position: Faker::Address.country, flag: "test" , currency: Faker:: Currency.name )
end
country = Country.create(name: "South Korea", position: "South Korea", flag: "test" , currency: Faker:: Currency.name )


puts "Country has been created"

5.times do 
    City.create(name: Faker::Address.city, address: Faker::Address.full_address ,climat:"test", description:"test", timezone:"test",traditions:"test", flag: "test", picture: "test", emblems: "test", country: Country.all.sample)
    
end 
city = City.create(name: "Seoul", address: "Seoul, South Korea", climat:"test", description:"test", timezone:"test",traditions:"test", flag: "test", picture: "test", emblems: "test", country: country) 
puts "City has been created"


ActivitiesCategory.create(name: "Attraction")
ActivitiesCategory.create(name: "Parks & Gardens")
ActivitiesCategory.create(name: "Landmarks")
ActivitiesCategory.create(name: "Historic sites")
ActivitiesCategory.create(name: "Art museums")
ActivitiesCategory.create(name: "Shopping area & Mall")
ActivitiesCategory.create(name: "Show / Animation")

puts "Categories has been created"
puts "Creation of activities in progress ....."

finish = file.size-1
for number in (1..finish)
    Activity.create(name: file[number][0], address: file[number][1], price: file[number][2], picture: file[number][3], description: file[number][4], city: city, activities_category: ActivitiesCategory.where(name: file[number][5]).first)
end

