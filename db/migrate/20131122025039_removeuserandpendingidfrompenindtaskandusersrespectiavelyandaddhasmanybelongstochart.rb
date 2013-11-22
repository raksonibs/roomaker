class Removeuserandpendingidfrompenindtaskandusersrespectiavelyandaddhasmanybelongstochart < ActiveRecord::Migration
  def change
  	remove_column :pendingtasks, :user_id
  	remove_column :users, :user_id
  	create_table :pendingtasks_users do |t|
  		t.belongs_to :pendingtask
  		t.belongs_to :user
  	end
  end
end
