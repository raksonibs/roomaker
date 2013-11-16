class CreateCompletedtasks < ActiveRecord::Migration
  def change
    create_table :completedtasks do |t|
      t.string :text
      t.integer :user_id

      t.timestamps
    end
  end
end
