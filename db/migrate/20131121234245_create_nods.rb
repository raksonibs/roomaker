class CreateNods < ActiveRecord::Migration
  def change
    create_table :nods do |t|
      t.integer :pendingtask_id
      t.integer :amount

      t.timestamps
    end
  end
end
