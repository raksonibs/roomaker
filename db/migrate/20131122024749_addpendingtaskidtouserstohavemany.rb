class Addpendingtaskidtouserstohavemany < ActiveRecord::Migration
  def change
  	add_column :pendingtasks, :user_id, :integer
  end
end
