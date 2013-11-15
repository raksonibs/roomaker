class CreatePendingtasks < ActiveRecord::Migration
  def change
    create_table :pendingtasks do |t|
      t.string :text
      t.integer :user_id
      t.integer :assignee_id
      t.string :voter_ids

      t.timestamps
    end
  end
end
