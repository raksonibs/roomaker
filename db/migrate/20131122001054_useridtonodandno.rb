class Useridtonodandno < ActiveRecord::Migration
  def change
  	add_column :nods, :user_id, :integer
	add_column :nos, :user_id, :integer
  end
end
