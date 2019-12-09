
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

<<<<<<< HEAD
=======


puts "destruction terminée"
>>>>>>> development

puts "Desctruction of BDD done"

puts "Extraction of CSVs files"
activities_roma = CSV.read("activities_Roma.csv")
activities_seville = CSV.read("activities_Seville.csv")

#tickets = CSV.read("tickets_seoul.csv")
puts "Extraction done"

Country.create(name: "Spain", position: "Spain")
Country.create(name: "Italy", position: "Italy")

puts "Countries has been created"

City.create(name: "Seville", address: "Seville, Spain", country: Country.find_by(name: "Spain"))
City.create(name: "Roma", address: "Roma, Italy", country: Country.find_by(name: "Italy"))

    
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
    Activity.create(name: activities_roma[number][0], address: activities_roma[number][3], picture: activities_roma[number][4], description: activities_roma[number][2], city: City.find_by(name: "Roma"))
end

finish = activities_seville.size-1
for number in (1..finish)
    Activity.create(name: activities_seville[number][0], address: activities_seville[number][3], picture: activities_seville[number][4], description: activities_seville[number][2], city: City.find_by(name: "Seville"))
end

puts "Creation of tickets in progress ....."

#finish = tickets.size-1
#for number in (1..finish)
#    Ticket.create(name: tickets[number][0], price: tickets[number][1], duration: ((tickets[number][2].to_f)*60), description: "test", ticket_url: "test", category: "standard", activity: Activity.where(name: activities[number][0]).first)
#end
