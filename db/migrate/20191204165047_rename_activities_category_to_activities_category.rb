class RenameActivitiesCategoryToActivitiesCategory < ActiveRecord::Migration[5.2]
  def change
		rename_column :activities, :Activities_category_id, :activities_category_id
  end
end
