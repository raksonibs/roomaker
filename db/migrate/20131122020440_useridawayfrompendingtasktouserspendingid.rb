class Useridawayfrompendingtasktouserspendingid < ActiveRecord::Migration
  def change
  	add_column :users, :pendingtask_id, :integer
  	remove_column :pendingtasks, :user_id
  end
end
