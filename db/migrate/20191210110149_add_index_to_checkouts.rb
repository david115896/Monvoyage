class AddIndexToCheckouts < ActiveRecord::Migration[5.2]
  def change
		add_column :checkouts, :index, :integer
  end
end
