class AddCompleteridtocompleted < ActiveRecord::Migration
  def change
  	add_column :completedtasks, :completer_id, :integer
  end
end
