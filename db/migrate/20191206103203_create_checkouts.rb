class CreateCheckouts < ActiveRecord::Migration[5.2]
  def change
    create_table :checkouts do |t|

			t.boolean :selected
			t.boolean :paid

      t.belongs_to :ticket, index: true
      t.belongs_to :organiser, index: true

      t.timestamps
    end
  end
end
