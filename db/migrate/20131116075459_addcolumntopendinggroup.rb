class Addcolumntopendinggroup < ActiveRecord::Migration
  def change
  	add_column :pendingtasks, :group, :string
  end
end
