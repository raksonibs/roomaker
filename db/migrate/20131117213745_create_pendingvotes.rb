class CreatePendingvotes < ActiveRecord::Migration
  def change
    create_table :pendingvotes do |t|
	  t.string :text
      t.integer :pendingtask_id
      t.timestamps
    end
  end
end