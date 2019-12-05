class AddReferenceToTicketsInOrganizer < ActiveRecord::Migration[5.2]
  def change
    add_reference :organizers, :ticket, foreign_key: true

  end
end
