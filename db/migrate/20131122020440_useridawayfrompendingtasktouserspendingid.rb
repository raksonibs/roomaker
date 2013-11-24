class Useridawayfrompendingtasktouserspendingid < ActiveRecord::Migration
  def change
  	add_column :users, :pendingtask_id, :integer
  	
  end
end
