class CreateCurrenttasks < ActiveRecord::Migration
  def change
    create_table :currenttasks do |t|
      t.string :text
      t.integer :user_id

      t.timestamps
    end
  end
end
