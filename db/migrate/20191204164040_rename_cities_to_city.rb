class RenameCitiesToCity < ActiveRecord::Migration[5.2]
  def change
		rename_column :activities, :Cities_id, :city_id
  end
end
