class CreateAcceptedtasks < ActiveRecord::Migration
  def change
    create_table :acceptedtasks do |t|
      t.string :text
      t.integer :user_id

      t.timestamps
    end
  end
end
