class AddThresholdtoPending < ActiveRecord::Migration
  def change
  	add_column :pendingtasks, :threshold, :integer
  end
end
