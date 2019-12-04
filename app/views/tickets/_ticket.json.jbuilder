json.extract! ticket, :id, :name, :description, :price, :ticket_url, :category, :duration, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
