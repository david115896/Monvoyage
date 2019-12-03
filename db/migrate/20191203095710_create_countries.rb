class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.stringposition :name
      t.string :flag
      t.string :currency
      t.string :currency

      t.timestamps
    end
  end
end
