class CreateOrganizers < ActiveRecord::Migration[5.2]
  def change
    create_table :organizers do |t|


      t.timestamps
    end
  end
end
