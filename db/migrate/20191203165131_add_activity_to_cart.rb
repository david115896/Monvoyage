class AddActivityToCart < ActiveRecord::Migration[5.2]
  def change
		add_reference :carts, :activity, index: true
  end
end
