class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|

			t.string :name
			t.string :address
			t.decimal :price
			t.text :description
			t.string :picture
			
			t.belongs_to :city, index: true
			t.belongs_to :activities_category, index: true

      t.timestamps
    end
  end
end
