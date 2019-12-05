class CreateSoldTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :sold_tickets do |t|
      t.belongs_to :ticket, index: true
      t.belongs_to :order, index: true
      t.timestamps
    end
  end
end
