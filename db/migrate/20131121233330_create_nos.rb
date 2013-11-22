class CreateNos < ActiveRecord::Migration
  def change
    create_table :nos do |t|
      t.integer :pendingtask_id
      t.integer :amount

      t.timestamps
    end
  end
end
