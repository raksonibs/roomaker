class Addfilleridtopendingtasks < ActiveRecord::Migration
  def change
  	add_column :pendingtasks, :filler_id, :integer
  end
end
