class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.string :ticket_url
      t.string :category
      t.datetime :duration

      t.timestamps
    end
  end
end
