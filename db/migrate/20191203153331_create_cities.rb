class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :address
      t.text :climat
      t.text :description
      t.string :timezone
      t.text :traditions
      t.text :flag
      t.string :picture
      t.string :emblems
      t.belongs_to :country, index: true
      t.timestamps
    end
  end
end
