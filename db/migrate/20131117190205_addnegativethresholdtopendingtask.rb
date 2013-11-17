class Addnegativethresholdtopendingtask < ActiveRecord::Migration
  def change
  	add_column :pendingtasks, :negthreshold, :integer
  end
end
