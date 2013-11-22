class CreateYes < ActiveRecord::Migration
  def change
    create_table :yes do |t|
      t.integer :pendingtask_id
      t.integer :amount

      t.timestamps
    end
  end
end
