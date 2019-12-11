class AddColumnDayToCheckouts < ActiveRecord::Migration[5.2]
  def change
		add_column :checkouts, :day, :integer
  end
end
