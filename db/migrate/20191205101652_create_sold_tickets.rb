class CreateSoldTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :sold_tickets do |t|

      t.timestamps
    end
  end
end
