class Removeuserandpendingidfrompenindtaskandusersrespectiavelyandaddhasmanybelongstochart < ActiveRecord::Migration
  def change
  	
  	
  	create_table :pendingtasks_users do |t|
  		t.belongs_to :pendingtask
  		t.belongs_to :user
  	end
  end
end
