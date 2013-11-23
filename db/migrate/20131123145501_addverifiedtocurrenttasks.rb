class Addverifiedtocurrenttasks < ActiveRecord::Migration
  def change
  	add_column :currenttasks, :verified, :integer
  end
end
