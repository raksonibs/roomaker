class Addcompleteridtoacceptedtasks < ActiveRecord::Migration
  def change
  	add_column :acceptedtasks, :completer_id, :integer
  end
end
