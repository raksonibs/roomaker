class Addcolumntacceptedandcurrent < ActiveRecord::Migration
  def change

  	add_column :acceptedtasks, :group, :string
  	add_column :currenttasks, :group, :string

  end
end
