class CreateAsks < ActiveRecord::Migration
  def change
    create_table :asks do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :asker_id
      t.timestamps
    end
  end
end
