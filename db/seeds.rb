
puts "Desctruction of BDD ... "
Country.destroy_all
City.destroy_all
ActivitiesCategory.destroy_all
Activity.destroy_all
User.destroy_all
Cart.destroy_all
Organiser.destroy_all
Order.destroy_all
SoldTicket.destroy_all
Ticket.destroy_all
Checkout.destroy_all


puts "Desctruction of BDD done"

puts "Extraction of CSVs files"
activities_roma = CSV.read("activities_Roma.csv")
activities_seville = CSV.read("activities_Seville.csv")
tickets_seville = CSV.read("tickets_Seville.csv")
tickets_seville = CSV.read("tickets_Seville.csv")
cities_info = CSV.read("5_cities_descriptions.csv")

#tickets = CSV.read("tickets_seoul.csv")
puts "Extraction done"

Country.create(name: "Spain", position: "Spain")
Country.create(name: "Italy", position: "Italy")
Country.create(name: "Japan", position: "Japan")
Country.create(name: "Bresil", position: "Bresil")
Country.create(name: "South Korea", position: "South-Korea")

puts "Countries has been created"

finish = cities_info.size-1
for number in (1..finish)
    City.create(name: cities_info[number][0], address: cities_info[number][1], country: Country.find_by(name: cities_info[number][2]), climat: cities_info[number][3], description: cities_info[number][4], timezone: cities_info[number][5], traditions: cities_info[number][6], flag: cities_info[number][7], picture: cities_info[number][8] )
end
#City.create(name: "Seville", address: "Seville, Spain", country: Country.find_by(name: "Spain"))
#City.create(name: "Roma", address: "Roma, Italy", country: Country.find_by(name: "Italy"))
#City.create(name: "Tokyo", address: "Tokyo, Japan", country: Country.find_by(name: "Japan"))
#City.create(name: "Rio De Janeiro", address: "Rio De Janeiro, Bresil", country: Country.find_by(name: "Bresil"))
    
puts "Cities has been created"

ActivitiesCategory.create(name: "Attraction")
ActivitiesCategory.create(name: "Parks & Gardens")
ActivitiesCategory.create(name: "Landmarks")
ActivitiesCategory.create(name: "Historic sites")
ActivitiesCategory.create(name: "Art museums")
ActivitiesCategory.create(name: "Shopping area & Mall")
ActivitiesCategory.create(name: "Show / Animation")

puts "Categories has been created"
puts "Creation of activities in progress ....."

finish = activities_roma.size-1
for number in (1..finish)
    Activity.create(name: activities_roma[number][0],description: activities_roma[number][1], address: activities_roma[number][2], picture: activities_roma[number][3] , city: City.find_by(name: activities_roma[number][4]), activities_category: ActivitiesCategory.find_by(name: activities_roma[number][5]))
end

finish = activities_seville.size-1
for number in (1..finish)
    Activity.create(name: activities_seville[number][0],description: activities_seville[number][1], address: activities_seville[number][2], picture: activities_seville[number][3] , city: City.find_by(name: activities_seville[number][4]), activities_category: ActivitiesCategory.find_by(name: activities_seville[number][5]))
end

puts "Activities added."


puts "Creation of tickets in progress ....."

finish = tickets_seville.size-1
for number in (1..finish)
    Ticket.create!(name: tickets_seville[number][0], duration: ((tickets_seville[number][1].to_f)*60), price: tickets_seville[number][2], category: tickets_seville[number][3], activity: Activity.find_by(name: tickets_seville[number][4]))
end

puts "Tickets added"

User.create(email: "jean@yopm.com", password: "azerty", is_admin: false)
User.create(email: "gluglu@yopmail.com", password: "azerty", is_admin: true)
User.create(email: "yoyo@yopmail.com", password: "azerty", is_admin: true)
User.create(email: "hibou@yopmail.com", password: "azerty", is_admin: true)
Organiser.create(user_id: User.all.sample.id, city_id: City.all.sample.id, duration: 1)
Checkouts.create(organiser_id: Organiser.all.first.id, ticket_id: Ticket.all.first.id, selected: false, paid: false)
