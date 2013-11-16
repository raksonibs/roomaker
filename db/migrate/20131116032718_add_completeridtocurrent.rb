class AddCompleteridtocurrent < ActiveRecord::Migration
  def change
  	add_column :currenttasks, :completer_id, :integer
  end
end
