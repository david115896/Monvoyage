class AddColumnDurationToOrganisers < ActiveRecord::Migration[5.2]
  def change
		add_column :organisers, :duration, :integer
  end
end
