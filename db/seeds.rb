
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
tickets_roma = CSV.read("tickets_Roma.csv")
cities_info = CSV.read("5_cities_descriptions.csv")

puts "Extraction done"

Country.create!(name: "Spain", position: "Spain")
Country.create!(name: "Italy", position: "Italy")
Country.create!(name: "Japan", position: "Japan")
Country.create!(name: "Bresil", position: "Bresil")
Country.create!(name: "South Korea", position: "South-Korea")

puts "Countries has been created"

finish = cities_info.size-1
for number in (1..finish)
    City.create!(name: cities_info[number][0], address: cities_info[number][1], country: Country.find_by(name: cities_info[number][2]), climat: cities_info[number][3], description: cities_info[number][4], timezone: cities_info[number][5], traditions: cities_info[number][6], flag: cities_info[number][7], picture: cities_info[number][8], latitude: cities_info[number][9], longitude: cities_info[number][10] )
end
    
puts "Cities has been created"

ActivitiesCategory.create!(name: "Attraction")
ActivitiesCategory.create!(name: "Parks & Gardens")
ActivitiesCategory.create!(name: "Landmarks")
ActivitiesCategory.create!(name: "Historic sites")
ActivitiesCategory.create!(name: "Art museums")
ActivitiesCategory.create!(name: "Shopping area & Mall")
ActivitiesCategory.create!(name: "Show / Animation")

puts "Categories has been created"
puts "Creation of activities in progress ....."

finish = activities_roma.size-1
for number in (1..finish)
    Activity.create!(name: activities_roma[number][0],description: activities_roma[number][1], address: activities_roma[number][2], picture: activities_roma[number][3] , city: City.find_by(name: activities_roma[number][4]), activities_category: ActivitiesCategory.find_by(name: activities_roma[number][5]), latitude: activities_roma[number][6], longitude: activities_roma[number][7] )
end

finish = activities_seville.size-1
for number in (1..finish)
    Activity.create!(name: activities_seville[number][0],description: activities_seville[number][1], address: activities_seville[number][2], picture: activities_seville[number][3] , city: City.find_by(name: activities_seville[number][4]), activities_category: ActivitiesCategory.find_by(name: activities_seville[number][5]), latitude: activities_seville[number][6], longitude: activities_seville[number][7])
end

puts "Activities added."


puts "Creation of tickets in progress ....."

finish = tickets_seville.size-1
for number in (1..finish)
     Ticket.create!(name: tickets_seville[number][0], duration: ((tickets_seville[number][1].to_f)*60), price: tickets_seville[number][2], category: tickets_seville[number][3], activity: Activity.find_by(name: tickets_seville[number][4]))
end

finish = tickets_roma.size-1
for number in (1..finish)
    Ticket.create!(name: tickets_roma[number][0], duration: ((tickets_roma[number][1].to_f)*60), price: tickets_roma[number][2], category: tickets_roma[number][3], activity: Activity.find_by(name: tickets_roma[number][4]))
end

puts "Tickets added"
puts "Creation of User and Admins in progress ....."

User.create!(email: "jean@yopm.com", password: "azerty", is_admin: false)
User.create!(email: "gluglu@yopmail.com", password: "azerty")
User.last.update!(is_admin: true, first_name: "gluglu", last_name: "gluglu", address: "Somewhere" )
User.create!(email: "yoyo@yopmail.com", password: "azerty")
User.last.update!(is_admin: true, first_name: "yoyo", last_name: "yoyo", address: "Somewhere")
User.create!(email: "hibou@yopmail.com", password: "azerty")
User.last.update!(is_admin:  true, first_name: "hibou", last_name: "hibou", address: "Somewhere")

puts "One user and 3 admins added"


Organiser.create!(user_id: User.all.sample.id, city_id: City.all.sample.id, duration: 1)
Checkout.create!(organiser_id: Organiser.all.first.id, ticket_id: Ticket.all.first.id, selected: false, paid: false)
