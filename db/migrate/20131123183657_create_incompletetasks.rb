class CreateIncompletetasks < ActiveRecord::Migration
  def change
    create_table :incompletetasks do |t|
      t.string :text
      t.integer :user_id
      t.integer  :completer_id
      t.string   :group

      t.timestamps
    end
  end
end
