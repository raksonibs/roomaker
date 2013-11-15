class AddPointstoPending < ActiveRecord::Migration
  def change
  	add_column :pendingtasks, :points, :integer
  end
end
