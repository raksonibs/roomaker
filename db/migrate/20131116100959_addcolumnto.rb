class Addcolumnto < ActiveRecord::Migration
  def change
  	add_column :completedtasks, :group, :string
  end
end
